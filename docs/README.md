# Tally — 文档索引

> 一款面向个人用户的 iOS 记账 App，覆盖日常支出、投资理财、人情借贷三大场景。
> 技术栈：**SwiftUI + SwiftData（iOS 17+）**，数据本地优先，iCloud 同步可选。

---

## 文档目录

| 文档 | 说明 |
|------|------|
| [PRD.md](./PRD.md) | 产品需求文档（功能需求、非功能需求、版本规划） |
| [product-design.md](./product-design.md) | 产品形态（信息架构、页面流程、线框、图表规范） |
| [data-model.md](./data-model.md) | 数据模型（SwiftData 实体、ER 图、字段说明） |
| [api-integration.md](./api-integration.md) | 投资模块行情接入方案（PriceProvider 协议、数据源选型） |
| [prd-comparison-review.md](./prd-comparison-review.md) | 与 ChatGPT 版 PRD 的对比评审与吸收记录 |

---

## 阅读顺序建议

1. **PRD.md** — 理解产品目标与完整功能需求
2. **product-design.md** — 理解页面结构与交互形态
3. **data-model.md** — 理解底层数据结构
4. **api-integration.md** — 理解投资模块的扩展能力

---

## 版本与状态

| 版本 | 日期 | 状态 | 说明 |
|------|------|------|------|
| v0.1 | 2026-06-13 | 草稿 | 初始需求文档与产品设计 |

---

## 术语表 (Glossary)

| 中文 | 英文 / 代码术语 | 说明 |
|------|----------------|------|
| 日常账本 | Daily Ledger / `Expense` | 记录日常收支的核心模块 |
| 账户 | Account | 资金账户（现金/微信/支付宝/银行卡/信用卡/证券/交易所…），余额计入净资产 |
| 转账 | Transfer (`type = .transfer`) | 账户间调拨，不计入收支统计 |
| 投资理财 | Investment / `Holding` | 管理多平台持仓资产的模块 |
| 投资交易 | InvestmentTransaction | 某持仓的买/卖/分红/空投等交易流水，用于推导成本与已实现盈亏 |
| 信用账本 | Credit Ledger / `Debt` | 记录借贷往来的模块 |
| 支出 | Expense | 金额流出（`type = .expense`） |
| 收入 | Income | 金额流入（`type = .income`） |
| 分类 | Category | 用户可自定义的支出/收入分类 |
| 标的 | Symbol | 投资品代码，如 `AAPL`、`BTC`、`600519` |
| 持仓 | Holding | 某一标的的持有记录 |
| 平台 | Platform | 资产所在投资平台，如富途、币安、支付宝 |
| 资产类别 | AssetClass | 加密货币 / 美股 / A股 / 基金 / 其他 |
| 对手方 | Counterparty | 借贷关系中的另一方（朋友/家人/机构） |
| 方向 | DebtDirection | 我欠 (`iOwe`) / 外债 (`owedToMe`) |
| 结算状态 | DebtStatus | 未结清 (`open`) / 部分还清 (`partial`) / 已结清 (`settled`) |
| 行情提供者 | PriceProvider | 提供实时价格的数据源抽象协议 |
| 净资产 | Net Worth | 账户余额合计 + 投资市值 + 应收 − 应付（个人资产负债表口径） |
| 本地优先 | Local-first | 数据默认存储在设备，不依赖网络或云端 |
