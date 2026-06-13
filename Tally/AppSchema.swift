import Foundation
import SwiftData

/// 集中声明应用的 SwiftData 模型集合，供 `modelContainer` 与预览复用。
enum AppSchema {
    static let models: [any PersistentModel.Type] = [
        Account.self,
        Category.self,
        Expense.self,
        Platform.self,
        Holding.self,
        InvestmentTransaction.self,
        PriceSnapshot.self,
        Counterparty.self,
        Debt.self,
        Repayment.self,
    ]

    /// 仅用于 SwiftUI 预览的内存容器（不落盘）。
    @MainActor
    static var previewContainer: ModelContainer = {
        let schema = Schema(models)
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("无法创建预览 ModelContainer: \(error)")
        }
    }()
}
