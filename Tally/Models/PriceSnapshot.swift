import Foundation
import SwiftData

/// 价格历史快照，用于绘制总市值趋势折线图（按标的保留最近 365 条）。
@Model
final class PriceSnapshot {
    @Attribute(.unique) var id: UUID
    var price: Decimal
    var currency: String
    var timestamp: Date

    var holding: Holding?

    init(
        id: UUID = UUID(),
        price: Decimal,
        currency: String,
        timestamp: Date = .now,
        holding: Holding? = nil
    ) {
        self.id = id
        self.price = price
        self.currency = currency
        self.timestamp = timestamp
        self.holding = holding
    }
}
