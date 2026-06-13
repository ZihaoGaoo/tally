import Foundation
import SwiftData

/// 借贷对手方（个人或机构，如朋友 / 信用卡 / 花呗 / 银行）。
@Model
final class Counterparty {
    @Attribute(.unique) var id: UUID
    var name: String
    var contactInfo: String?
    /// 无头像时显示的缩写底色。
    var avatarColorHex: String

    @Relationship(deleteRule: .deny, inverse: \Debt.counterparty)
    var debts: [Debt]

    init(
        id: UUID = UUID(),
        name: String,
        contactInfo: String? = nil,
        avatarColorHex: String = "#8E8E93"
    ) {
        self.id = id
        self.name = name
        self.contactInfo = contactInfo
        self.avatarColorHex = avatarColorHex
        self.debts = []
    }
}
