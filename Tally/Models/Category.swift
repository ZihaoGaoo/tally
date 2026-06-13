import Foundation
import SwiftData

/// 支出/收入分类。预置分类不可删除但可隐藏。
@Model
final class Category {
    @Attribute(.unique) var id: UUID
    var name: String
    var sfSymbol: String
    var colorHex: String
    var isPreset: Bool
    var isHidden: Bool
    var sortOrder: Int
    /// 若指定，限定此分类只用于收入或支出。
    var expenseType: ExpenseType?

    /// 反向关系：删除分类时若仍有关联流水则拒绝（.deny）。
    @Relationship(deleteRule: .deny, inverse: \Expense.category)
    var expenses: [Expense]

    init(
        id: UUID = UUID(),
        name: String,
        sfSymbol: String,
        colorHex: String,
        isPreset: Bool = false,
        isHidden: Bool = false,
        sortOrder: Int = 0,
        expenseType: ExpenseType? = nil
    ) {
        self.id = id
        self.name = name
        self.sfSymbol = sfSymbol
        self.colorHex = colorHex
        self.isPreset = isPreset
        self.isHidden = isHidden
        self.sortOrder = sortOrder
        self.expenseType = expenseType
        self.expenses = []
    }
}
