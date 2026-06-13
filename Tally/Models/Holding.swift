import Foundation
import SwiftData

/// 投资持仓。`quantity` / `costPrice` 优先由交易流水按移动加权平均推导。
@Model
final class Holding {
    @Attribute(.unique) var id: UUID
    var symbol: String
    var name: String
    var assetClass: AssetClass
    var quantity: Decimal
    var costPrice: Decimal
    var currentPrice: Decimal?
    var currency: String
    var lastUpdated: Date?
    var note: String?
    var createdAt: Date

    var platform: Platform

    @Relationship(deleteRule: .cascade, inverse: \InvestmentTransaction.holding)
    var transactions: [InvestmentTransaction]

    @Relationship(deleteRule: .cascade, inverse: \PriceSnapshot.holding)
    var priceHistory: [PriceSnapshot]

    init(
        id: UUID = UUID(),
        symbol: String,
        name: String,
        assetClass: AssetClass,
        platform: Platform,
        quantity: Decimal = 0,
        costPrice: Decimal = 0,
        currentPrice: Decimal? = nil,
        currency: String = "USD",
        lastUpdated: Date? = nil,
        note: String? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.assetClass = assetClass
        self.platform = platform
        self.quantity = quantity
        self.costPrice = costPrice
        self.currentPrice = currentPrice
        self.currency = currency
        self.lastUpdated = lastUpdated
        self.note = note
        self.createdAt = createdAt
        self.transactions = []
        self.priceHistory = []
    }

    // MARK: - 计算属性（不持久化）

    /// 当前市值。
    var marketValue: Decimal { (currentPrice ?? 0) * quantity }
    /// 持仓成本总额。
    var costValue: Decimal { costPrice * quantity }
    /// 未实现浮动盈亏。
    var unrealizedGain: Decimal { marketValue - costValue }
    /// 持仓收益率（%）。
    var gainLossPercent: Double {
        guard costValue != 0 else { return 0 }
        return NSDecimalNumber(decimal: unrealizedGain / costValue).doubleValue * 100
    }
    /// 价格是否过期（超过 1 小时未更新）。
    var isPriceStale: Bool {
        guard let lastUpdated else { return true }
        return lastUpdated < Date.now.addingTimeInterval(-3600)
    }
}
