import SwiftUI
import SwiftData

/// 投资汇总：总市值/盈亏、资产配置、分组列表、风险集中度提醒。
struct PortfolioView: View {
    enum GroupMode: String, CaseIterable, Identifiable {
        case platform, assetClass
        var id: String { rawValue }
        var title: String { self == .platform ? "按平台" : "按类别" }
    }

    @State private var groupMode: GroupMode = .platform
    @Query(sort: \Holding.createdAt, order: .reverse) private var holdings: [Holding]

    var body: some View {
        NavigationStack {
            Group {
                if holdings.isEmpty {
                    EmptyStateView(
                        systemImage: "chart.line.uptrend.xyaxis",
                        message: "添加你的第一个持仓"
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            SummaryCard(title: "总市值（折合 CNY）", trailingValue: "¥ --") {
                                Text("成本 ¥-- · 浮盈 ¥-- · 已实现 ¥--")
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                            Picker("分组", selection: $groupMode) {
                                ForEach(GroupMode.allCases) { Text($0.title).tag($0) }
                            }
                            .pickerStyle(.segmented)

                            // TODO: 资产配置甜甜圈图、分组持仓列表、盈亏排行、>50% 风险集中度提醒。
                            ForEach(holdings) { holding in
                                NavigationLink {
                                    HoldingDetailView(holding: holding)
                                } label: {
                                    holdingRow(holding)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("投资")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button { /* TODO: 新增持仓 */ } label: { Image(systemName: "plus") }
                    Button { /* TODO: 刷新价格 */ } label: { Image(systemName: "arrow.clockwise") }
                }
            }
        }
    }

    private func holdingRow(_ holding: Holding) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(holding.name)
                Text("\(holding.symbol) · \(holding.platform.name)")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(holding.marketValue.formatted())
                .monospacedDigit()
            if holding.isPriceStale {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.tallyWarning)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PortfolioView().modelContainer(AppSchema.previewContainer)
}
