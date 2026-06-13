import SwiftUI
import SwiftData

/// 总览：净资产全貌 + 各模块摘要。
/// 净资产 = 账户余额合计 + 投资市值 + 应收 − 应付。
struct OverviewView: View {
    @Query private var accounts: [Account]
    @Query private var holdings: [Holding]
    @Query private var debts: [Debt]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    SummaryCard(title: "净资产 Net Worth") {
                        // TODO: 接入净资产计算（NetWorthService）。
                        Text("¥ --")
                            .font(.largeTitle.bold())
                            .monospacedDigit()
                        Text("= 账户余额 + 投资市值 + 应收 − 应付")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    SummaryCard(title: "账户余额", trailingValue: "¥ --") {
                        Text("现金 / 银行 / 钱包合计")
                            .font(.caption).foregroundStyle(.secondary)
                    }

                    SummaryCard(title: "投资资产", trailingValue: "¥ --") {
                        Text("今日盈亏 / 累计盈亏")
                            .font(.caption).foregroundStyle(.secondary)
                    }

                    SummaryCard(title: "信用净额", trailingValue: "¥ --") {
                        Text("应收 − 应付")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Tally")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}

#Preview {
    OverviewView().modelContainer(AppSchema.previewContainer)
}
