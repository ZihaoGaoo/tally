import Foundation
import SwiftData

/// 投资交易流水。新增/编辑/删除后回放该持仓全部交易，重算数量/成本/已实现盈亏。
@Model
final class InvestmentTransaction {
    @Attribute(.unique) var id: UUID
    var type: InvestmentTxType
    var quantity: Decimal
    var price: Decimal
    var fee: Decimal
    var currency: String
    var date: Date
    var note: String?

    var holding: Holding?
    /// 出资/收款账户（买入扣现金、卖出/分红入现金）。
    var fundingAccount: Account?

    init(
        id: UUID = UUID(),
        type: InvestmentTxType,
        quantity: Decimal,
        price: Decimal,
        fee: Decimal = 0,
        currency: String = "USD",
        date: Date = .now,
        note: String? = nil,
        holding: Holding? = nil,
        fundingAccount: Account? = nil
    ) {
        self.id = id
        self.type = type
        self.quantity = quantity
        self.price = price
        self.fee = fee
        self.currency = currency
        self.date = date
        self.note = note
        self.holding = holding
        self.fundingAccount = fundingAccount
    }
}
