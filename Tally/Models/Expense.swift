import Foundation
import SwiftData

/// 日常流水（支出 / 收入 / 转账）。
/// 转账时 `account` 为转出账户、`transferToAccount` 为转入账户，且不计入收支统计。
@Model
final class Expense {
    @Attribute(.unique) var id: UUID
    var name: String
    var amount: Decimal
    var currency: String
    var type: ExpenseType
    var date: Date
    var note: String?
    var tags: [String]
    /// 图片凭证（本地文件引用）。
    var attachments: [String]
    var createdAt: Date

    var category: Category
    /// 出账/入账账户（取代旧 paymentMethod 字符串）。
    var account: Account
    /// 转入账户，仅 `type == .transfer` 时有值。
    var transferToAccount: Account?

    init(
        id: UUID = UUID(),
        name: String,
        amount: Decimal,
        type: ExpenseType = .expense,
        category: Category,
        account: Account,
        transferToAccount: Account? = nil,
        currency: String = "CNY",
        date: Date = .now,
        note: String? = nil,
        tags: [String] = [],
        attachments: [String] = [],
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.category = category
        self.account = account
        self.transferToAccount = transferToAccount
        self.currency = currency
        self.date = date
        self.note = note
        self.tags = tags
        self.attachments = attachments
        self.createdAt = createdAt
    }
}
