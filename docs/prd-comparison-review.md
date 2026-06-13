# Tally — PRD 对比评审（Claude plan vs ChatGPT PRD）

> **版本**: v0.1 | **日期**: 2026-06-13
> 本文记录将本仓库设计（`docs/` 下 4 篇）与 Notion 上一版 ChatGPT 设计的
> 《iOS 个人记账与资产管理 App PRD》对比后的结论，作为后续修订的决策依据。

---

## 一、总体结论

现有 Tally 设计在**工程严谨度**上整体强于 ChatGPT PRD，但 ChatGPT PRD 在
**产品完整性**上有若干被本设计漏掉的好点子，已按优先级吸收进现有文档。

| 维度 | 现有 Claude 设计 | ChatGPT PRD |
|------|----------------|-------------|
| 数据持久化 | ✅ SwiftData `@Model` + ER 图 + 版本迁移策略 | ⚠️ 仅伪代码字段列表，金额用浮点 |
| 金额精度 | ✅ `Decimal` | ❌ 浮点小数（有舍入风险） |
| 行情接入 | ✅ `PriceProvider` 协议 + 数据源选型 + 限流/缓存/降级 | ⚠️ 仅列"可插拔 API"表，无协议/调度设计 |
| 引用完整性 | ✅ 级联删除/拒删规则 | ❌ 未提 |
| 价格历史 | ✅ `PriceSnapshot` 实体 | ⚠️ 文字提到"价格快照"，模型缺失 |
| 安全 | ✅ Keychain 存 Key + Face ID | ⚠️ 提到加密但不具体 |
| 非功能需求 | ✅ 无障碍/暗黑/性能 | ❌ 未覆盖 |
| **账户体系** | ❌ 无 Account 实体（仅字符串） | ✅ 统一 Account，余额进净资产 |
| **投资交易流水** | ❌ 仅静态持仓快照 | ✅ 完整交易记录实体 |
| **转账** | ❌ 无 | ✅ 支出/收入/转账三方向 |
| **凭证附件 / 分期 / CSV导入** | ❌ 缺 | ✅ 有 |

---

## 二、已吸收：ChatGPT PRD 里值得学习的设计

### Tier 1（架构级）

1. **统一 Account 实体，且账户余额纳入净资产** ★
   - ChatGPT 净资产口径：`日常账户余额 + 投资市值 + 应收 − 应付 − 信用负债`。
   - 原设计净资产 = 总资产市值 − 负债净额，**漏掉了现金/银行存款**这块最大的
     流动资产。已新增 `Account` 实体，`Expense` 关联 `Account`，余额由
     "期初余额 + Σ流水"推导，并修正净资产定义。

2. **InvestmentTransaction 投资交易流水**
   - 原 `Holding` 只有静态 `quantity + costPrice`，无法表达多次建仓/部分卖出/
     分红/空投，算不出已实现盈亏。已新增 `InvestmentTransaction`，持仓的数量与
     成本由交易按**移动加权平均**推导。

3. **转账（transfer）方向**
   - 账户间调拨（银行卡→支付宝）原本无法记录。已支持双腿转账
     （`fromAccount/toAccount`），且**不计入收支统计**。

### Tier 2（功能级）

4. **凭证 / 图片附件** —— `Expense` / `Debt` 增加可选本地图片附件。
5. **分期付款** —— `Debt` 增加 `isInstallment / installmentCount / perPeriodAmount`，
   覆盖花呗/信用卡分期/房贷/车贷场景，按期提醒。
6. **首页多模块快捷操作** —— FAB/总览页提供"记投资 / 记欠款 / 记别人欠我"入口，
   不止快速记一笔支出。
7. **CSV 导入 + 导出** —— 明确进版本规划，导入做字段映射（利于从其他 App 迁移）。

### Tier 3（体验增强，列入 backlog）

8. 风险集中度提醒（单一资产占比 >50%）。
9. 账单排行榜 / 持仓盈亏排行榜（原仅分类排行）。
10. 更丰富的到期提醒（到期前/当天/逾期/自定义/周期性）。
11. 预算管理（v1.x backlog）。
12. USDT 计价币种 / 还款关联账户（与 Account 配套过账）。

---

## 三、保留：现有设计优于 ChatGPT PRD、无需改动的地方

- `Decimal` 金额、SwiftData 建模与迁移、`PriceProvider` 协议化行情接入、
  级联完整性、`PriceSnapshot`、Keychain、无障碍/暗黑/性能 NFR、空状态/配色规范。
- 这些是 ChatGPT PRD 缺失或仅文字带过的部分，继续以本仓库设计为准。

---

## 四、修订对照表

| 吸收点 | 落地文档 |
|--------|---------|
| Account 实体 / 净资产口径 / 转账 | `data-model.md`、`PRD.md`、`product-design.md`、`README.md` |
| InvestmentTransaction | `data-model.md`、`PRD.md`、`product-design.md` |
| 凭证附件 / 分期 | `data-model.md`、`PRD.md` |
| 多模块快捷操作 / 排行榜 / 风险提醒 | `PRD.md`、`product-design.md` |
| CSV 导入导出 / 预算 backlog | `PRD.md` |
