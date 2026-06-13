import Foundation
import SwiftData

/// 统一资金账户。账户余额计入净资产；当前余额由"期初余额 + 关联流水"推导。
///
/// 说明：`Account` 被 `Expense`(account/transferToAccount)、`Repayment`(account)、
/// `InvestmentTransaction`(fundingAccount) 多处引用，为避免 SwiftData 反向关系歧义，
/// 这里不声明反向集合；余额通过查询聚合（见 BalanceService，TODO）。
@Model
final class Account {
    @Attribute(.unique) var id: UUID
    var name: String
    var type: AccountType
    var currency: String
    /// 期初余额（信用卡可为负，代表欠款）。
    var openingBalance: Decimal
    var isArchived: Bool
    var sortOrder: Int
    var note: String?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        type: AccountType,
        currency: String = "CNY",
        openingBalance: Decimal = 0,
        isArchived: Bool = false,
        sortOrder: Int = 0,
        note: String? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.currency = currency
        self.openingBalance = openingBalance
        self.isArchived = isArchived
        self.sortOrder = sortOrder
        self.note = note
        self.createdAt = createdAt
    }
}
