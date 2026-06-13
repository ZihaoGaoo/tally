import Foundation
import SwiftData

/// 借贷记录（应收 / 应付），支持分期与图片凭证。
@Model
final class Debt {
    @Attribute(.unique) var id: UUID
    var direction: DebtDirection
    var amount: Decimal
    /// 已还清金额（由 Repayment 累加）。
    var settledAmount: Decimal
    var currency: String
    var status: DebtStatus
    var date: Date
    var dueDate: Date?
    /// 年化利率（%），0 表示免息。
    var interest: Decimal?
    var isInstallment: Bool
    var installmentCount: Int?
    var perPeriodAmount: Decimal?
    var note: String?
    /// 凭证（借条/合同截图，本地文件引用）。
    var attachments: [String]

    var counterparty: Counterparty

    @Relationship(deleteRule: .cascade, inverse: \Repayment.debt)
    var repayments: [Repayment]

    init(
        id: UUID = UUID(),
        direction: DebtDirection,
        amount: Decimal,
        counterparty: Counterparty,
        settledAmount: Decimal = 0,
        currency: String = "CNY",
        status: DebtStatus = .open,
        date: Date = .now,
        dueDate: Date? = nil,
        interest: Decimal? = nil,
        isInstallment: Bool = false,
        installmentCount: Int? = nil,
        perPeriodAmount: Decimal? = nil,
        note: String? = nil,
        attachments: [String] = []
    ) {
        self.id = id
        self.direction = direction
        self.amount = amount
        self.counterparty = counterparty
        self.settledAmount = settledAmount
        self.currency = currency
        self.status = status
        self.date = date
        self.dueDate = dueDate
        self.interest = interest
        self.isInstallment = isInstallment
        self.installmentCount = installmentCount
        self.perPeriodAmount = perPeriodAmount
        self.note = note
        self.attachments = attachments
        self.repayments = []
    }

    // MARK: - 计算属性

    var remainingAmount: Decimal { amount - settledAmount }

    var isOverdue: Bool {
        guard let dueDate else { return false }
        return dueDate < .now && status != .settled
    }
}
