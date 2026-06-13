import Foundation
import SwiftData

/// 投资平台（富途、币安、支付宝基金等）。
@Model
final class Platform {
    @Attribute(.unique) var id: UUID
    var name: String
    var sfSymbol: String?
    var defaultCurrency: String
    var isPreset: Bool
    var sortOrder: Int

    @Relationship(deleteRule: .deny, inverse: \Holding.platform)
    var holdings: [Holding]

    init(
        id: UUID = UUID(),
        name: String,
        sfSymbol: String? = nil,
        defaultCurrency: String = "CNY",
        isPreset: Bool = false,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.sfSymbol = sfSymbol
        self.defaultCurrency = defaultCurrency
        self.isPreset = isPreset
        self.sortOrder = sortOrder
        self.holdings = []
    }
}
