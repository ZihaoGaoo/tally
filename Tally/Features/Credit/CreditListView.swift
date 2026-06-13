import SwiftUI
import SwiftData

/// 信用账本：应收/应付分组 + 净额汇总。
struct CreditListView: View {
    @Query(sort: \Debt.date, order: .reverse) private var debts: [Debt]

    private var receivables: [Debt] { debts.filter { $0.direction == .owedToMe && $0.status != .settled } }
    private var payables: [Debt] { debts.filter { $0.direction == .iOwe && $0.status != .settled } }

    var body: some View {
        NavigationStack {
            Group {
                if debts.isEmpty {
                    EmptyStateView(systemImage: "person.2", message: "暂无借贷记录")
                } else {
                    List {
                        Section {
                            HStack {
                                summary("应收（外债）", receivables)
                                summary("应付（我欠）", payables)
                            }
                        }
                        Section("外债（别人欠我）") {
                            ForEach(receivables) { debtRow($0) }
                        }
                        Section("我欠（我欠别人）") {
                            ForEach(payables) { debtRow($0) }
                        }
                        // TODO: 已结清记录折叠分组。
                    }
                }
            }
            .navigationTitle("信用账本")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { /* TODO: 新增借贷 */ } label: { Image(systemName: "plus") }
                }
            }
        }
    }

    private func summary(_ title: String, _ items: [Debt]) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(items.reduce(Decimal(0)) { $0 + $1.remainingAmount }.formatted())
                .font(.headline).monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func debtRow(_ debt: Debt) -> some View {
        NavigationLink {
            DebtDetailView(debt: debt)
        } label: {
            HStack {
                Text(debt.counterparty.name)
                Spacer()
                Text(debt.remainingAmount.formatted())
                    .monospacedDigit()
                if debt.isOverdue {
                    Text("逾期").font(.caption2).foregroundStyle(.tallyWarning)
                }
            }
        }
    }
}

#Preview {
    CreditListView().modelContainer(AppSchema.previewContainer)
}
