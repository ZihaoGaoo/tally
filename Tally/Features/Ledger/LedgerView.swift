import SwiftUI
import SwiftData

/// 日常账本：列表 / 统计 两视图切换。
struct LedgerView: View {
    enum Mode: String, CaseIterable, Identifiable {
        case list, stats
        var id: String { rawValue }
        var title: String { self == .list ? "列表" : "统计" }
    }

    @State private var mode: Mode = .list
    @State private var period: StatPeriod = .month
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("视图", selection: $mode) {
                    ForEach(Mode.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding()

                switch mode {
                case .list:
                    listView
                case .stats:
                    StatisticsView(period: $period)
                }
            }
            .navigationTitle("账本")
        }
    }

    @ViewBuilder
    private var listView: some View {
        if expenses.isEmpty {
            EmptyStateView(systemImage: "tray", message: "还没有记录，开始记第一笔吧")
        } else {
            List {
                // TODO: 按日分组 + 当日小计 + 区间汇总（收入/支出/结余，转账不计入）。
                ForEach(expenses) { expense in
                    HStack {
                        Text(expense.name)
                        Spacer()
                        Text(expense.amount.formatted())
                            .monospacedDigit()
                            .foregroundStyle(expense.type == .income ? .tallyIncome : .tallyExpense)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    LedgerView().modelContainer(AppSchema.previewContainer)
}
