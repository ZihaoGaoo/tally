import Foundation
import SwiftData

/// 还款记录。新增后自动更新 Debt 的 settledAmount 与 status；
/// 若指定 account，则同步计入账户余额变动。
@Model
final class Repayment {
    @Attribute(.unique) var id: UUID
    var amount: Decimal
    var date: Date
    var note: String?

    var debt: Debt?
    /// 还款方式（关联账户，可选）。
    var account: Account?

    init(
        id: UUID = UUID(),
        amount: Decimal,
        date: Date = .now,
        note: String? = nil,
        debt: Debt? = nil,
        account: Account? = nil
    ) {
        self.id = id
        self.amount = amount
        self.date = date
        self.note = note
        self.debt = debt
        self.account = account
    }
}
