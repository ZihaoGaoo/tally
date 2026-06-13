import SwiftUI
import SwiftData

/// 快速记账 Sheet：金额优先，分类 + 账户横向快捷选择。
struct QuickEntrySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Category.sortOrder) private var categories: [Category]
    @Query(sort: \Account.sortOrder) private var accounts: [Account]

    @State private var amountText: String = ""
    @State private var type: ExpenseType = .expense

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(amountText.isEmpty ? "¥ 0.00" : "¥ \(amountText)")
                    .font(.system(size: 40, weight: .semibold))
                    .monospacedDigit()
                    .padding(.top, 24)

                Picker("类型", selection: $type) {
                    ForEach(ExpenseType.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.segmented)

                // TODO: 横向滚动的快捷分类/账户、自定义数字键盘、转账收款账户。
                Text("分类 / 账户快捷选择（待实现）")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .navigationTitle("记一笔")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        // TODO: 校验并写入 Expense（含账户、转账腿）。
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    QuickEntrySheet().modelContainer(AppSchema.previewContainer)
}
