# Tally — 投资模块行情接入方案

> **版本**: v0.1 草稿 | **日期**: 2026-06-13
> 本文设计 `PriceProvider` 协议抽象及各资产类别的数据源选型，不包含真实 API Key。

---

## 一、设计目标

- 将"获取实时价格"的能力抽象为协议，使各资产类别的数据源**可插拔、可替换**。
- MVP 阶段（v0.3）使用手动价格录入（`ManualPriceProvider`）作为默认实现。
- v1.0 阶段接入真实 API，切换时只替换具体实现，不修改上层业务逻辑。

---

## 二、PriceProvider 协议设计

### 2.1 核心协议

```
protocol PriceProvider {
    /// 获取单个标的的当前报价
    func fetchQuote(symbol: String, assetClass: AssetClass) async throws -> PriceQuote

    /// 批量获取多个标的报价（减少 API 请求次数）
    func fetchQuotes(symbols: [(symbol: String, assetClass: AssetClass)]) async throws -> [PriceQuote]

    /// 该 Provider 支持的资产类别
    var supportedAssetClasses: Set<AssetClass> { get }
}
```

### 2.2 PriceQuote 数据结构

| 字段 | 类型 | 说明 |
|------|------|------|
| `symbol` | `String` | 标的代码 |
| `price` | `Decimal` | 当前价格 |
| `currency` | `String` | 计价币种（ISO 4217） |
| `change` | `Decimal?` | 今日涨跌额（可选） |
| `changePercent` | `Decimal?` | 今日涨跌幅 %（可选） |
| `timestamp` | `Date` | 价格时间戳 |
| `source` | `String` | 数据来源标识（如 `"CoinGecko"`） |

### 2.3 错误类型

```
enum PriceProviderError: Error {
    case symbolNotFound(String)        // 标的不存在
    case rateLimitExceeded             // 超出请求频率限制
    case networkUnavailable            // 无网络
    case invalidResponse               // 响应格式异常
    case authenticationFailed          // API Key 无效
    case assetClassNotSupported        // 该 Provider 不支持此资产类别
}
```

### 2.4 PriceProviderRegistry（协议调度器）

```
class PriceProviderRegistry {
    /// 注册 Provider，支持多个 Provider 覆盖不同资产类别
    func register(_ provider: PriceProvider, for assetClasses: Set<AssetClass>)

    /// 根据资产类别自动路由到对应 Provider
    func fetchQuote(symbol: String, assetClass: AssetClass) async throws -> PriceQuote

    /// 批量路由（按 assetClass 分组后并发请求）
    func fetchAllHoldings(_ holdings: [Holding]) async -> [String: Result<PriceQuote, Error>]
}
```

---

## 三、数据源选型

### 3.1 加密货币 (`.crypto`)

| 数据源 | 免费额度 | 认证方式 | 覆盖范围 | 延迟 |
|--------|---------|---------|---------|------|
| **CoinGecko API v3** | 10,000 次/月（免费） | 无需 Key（免费版）或 API Key | 1万+ 币种 | ~实时（15s 延迟） |
| CoinMarketCap | 10,000 次/月（免费） | API Key 必须 | 9,000+ 币种 | ~5min 延迟（免费版） |
| Binance REST API | 无限制（公开接口） | 无需 Key | 仅上线币种 | 实时 |

**推荐**：优先使用 **CoinGecko（无 Key 免费版）**，超出限额或需更低延迟时切换为 Binance 公开接口。

**端点示例**：
```
GET https://api.coingecko.com/api/v3/simple/price
  ?ids=bitcoin,ethereum
  &vs_currencies=usd,cny
```

---

### 3.2 美股 (`.usStock`)

| 数据源 | 免费额度 | 认证方式 | 覆盖范围 | 延迟 |
|--------|---------|---------|---------|------|
| **Yahoo Finance (非官方)** | 不限（非官方接口） | 无需 Key | 全市场（美股/ETF/指数） | ~实时（15min 延迟） |
| Alpha Vantage | 25 次/日（免费） | API Key 必须 | 美股 + 外汇 + 加密 | ~实时 |
| Finnhub | 60 次/分（免费） | API Key 必须 | 美股 + 全球市场 | 实时（WebSocket）|
| **Financial Modeling Prep (FMP)** | 250 次/日（免费） | API Key 必须 | 美股 + A股 ADR | ~实时 |

**推荐**：
- MVP 手动价格，**v1.0 使用 Finnhub（免费额度充足，支持批量）**。
- Yahoo Finance 非官方接口作为备选（不稳定，有被封风险）。

**注意事项**：
- 美股收盘后价格不再变动，刷新逻辑应判断交易时段（NYSE：UTC 14:30–21:00）。
- 需处理盘前/盘后价格（extended hours）的标注。

---

### 3.3 A股 (`.aShare`)

| 数据源 | 免费额度 | 认证方式 | 覆盖范围 | 延迟 |
|--------|---------|---------|---------|------|
| **新浪财经（非官方）** | 不限（非官方） | 无需 Key | 沪深全市场 | 实时（延迟15s） |
| 腾讯股票接口（非官方） | 不限（非官方） | 无需 Key | 沪深全市场 | 实时 |
| AKShare（Python库） | 开源 | 无需 Key | A股/港股/期货 | 不适用iOS直接调用 |
| **东方财富 EMC API** | 公开数据接口 | 无需 Key | 沪深全市场 | 实时 |

**推荐**：使用**腾讯股票公开接口**作为 A 股数据源（稳定性较好，延迟低）。

**端点示例**：
```
GET https://qt.gtimg.cn/q=sh600519,sz000858
响应格式：v_sh600519="1~贵州茅台~600519~1688.00~..."
```

**注意事项**：
- 非官方接口存在被封或格式变更的风险，需做好降级（手动价格）兜底。
- A股交易时段：工作日 09:30–11:30, 13:00–15:00（北京时间）。

---

### 3.4 港股 (`.hkStock`)

| 数据源 | 推荐方案 |
|--------|---------|
| Yahoo Finance | `0700.HK` 格式，与美股同一接口 |
| 腾讯接口 | `hk00700` 格式，覆盖港股 |

**推荐**：Finnhub 或腾讯接口均支持港股，与美股/A股共用同一 Provider 实现。

---

### 3.5 基金 (`.fund`)

- 国内基金（公募ETF）通过腾讯/新浪接口获取净值。
- 美股 ETF（SPY、QQQ 等）通过美股接口获取。
- 基金净值通常 T+1 日更新，无需实时刷新，每日定时（22:00 后）更新即可。

---

## 四、刷新与缓存策略

### 4.1 刷新触发

| 触发方式 | 时机 | 说明 |
|---------|------|------|
| 手动刷新 | 用户点击刷新按钮 | 立即请求所有持仓最新价格 |
| 应用前台激活 | `scenePhase == .active` | 若上次刷新距今 > 5 分钟，自动触发 |
| 后台刷新 | Background App Refresh | 可选，iOS 系统调度，不保证频率 |

### 4.2 节流 (Throttling)

- 同一标的 **60 秒内不重复请求**（避免超出 API 限额）。
- 批量请求：将所有持仓按 `assetClass` 分组，每组一次批量 API 调用。
- 并发：多个资产类别的请求并发执行（`async let` 或 `TaskGroup`）。

### 4.3 本地缓存

- 每次成功获取价格后：
  1. 更新 `Holding.currentPrice` + `Holding.lastUpdated`
  2. 写入一条 `PriceSnapshot`（用于趋势图）
- 离线状态下：使用 `Holding.currentPrice` 缓存值展示，并显示 `⚠ 价格已过期` 标注（超过 1 小时）。
- 应用启动时 **不自动请求**，避免冷启动时网络阻塞。

### 4.4 错误处理与降级

```
请求成功 → 更新价格 → 刷新 UI
请求失败（网络）→ 显示缓存价格 + ⚠ 提示
请求失败（频率限制）→ 等待 60s 后重试 + 用户提示"请求过于频繁"
请求失败（标的不存在）→ 标注该持仓"价格不可用"，不影响其他持仓
```

---

## 五、多币种汇率换算

### 5.1 换算流程

所有持仓以**原始计价币种**存储，汇总展示时换算为用户设置的基础货币（默认 CNY）：

```
marketValueInBaseCurrency = holding.marketValue × exchangeRate(from: holding.currency, to: baseCurrency)
```

### 5.2 汇率来源

| 方案 | 说明 |
|------|------|
| 手动配置（v0.3） | 用户在设置中手动输入汇率，如 1 USD = 7.25 CNY |
| ExchangeRate API（v1.0） | 免费，1500 次/月，支持主流货币对 |
| Frankfurter API（v1.0）| 欧洲央行数据，开源免费，每日更新 |

### 5.3 汇率缓存

- 汇率每日更新一次（非实时），缓存有效期 24 小时。
- 缓存于本地（UserDefaults 或 SwiftData `ExchangeRate` 实体）。
- 离线时使用最近一次缓存汇率，超过 7 天显示警告。

---

## 六、API Key 管理

- API Key **不硬编码**在代码中，存储于 iOS Keychain。
- 用户在设置页面输入自己的 API Key（高级用户），或使用内置免费额度的公开接口（无需 Key）。
- Key 不上传任何服务器，不包含在 iCloud 备份中（`kSecAttrAccessible = .whenUnlockedThisDeviceOnly`）。
