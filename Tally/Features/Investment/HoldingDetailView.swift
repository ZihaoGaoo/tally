import SwiftUI

/// 持仓详情：当前价/市值/盈亏 + 交易流水时间线 + 价格走势。
struct HoldingDetailView: View {
    let holding: Holding

    var body: some View {
        List {
            Section("持仓") {
                LabeledContent("现价", value: holding.currentPrice?.formatted() ?? "--")
                LabeledContent("数量", value: holding.quantity.formatted())
                LabeledContent("市值", value: holding.marketValue.formatted())
                LabeledContent("成本价", value: holding.costPrice.formatted())
                LabeledContent("未实现盈亏", value: holding.unrealizedGain.formatted())
            }

            Section("交易流水") {
                if holding.transactions.isEmpty {
                    Text("暂无交易记录").foregroundStyle(.secondary)
                } else {
                    // TODO: 时间线展示 InvestmentTransaction，并回放重算成本/已实现盈亏。
                    ForEach(holding.transactions) { tx in
                        HStack {
                            Text(tx.type.title)
                            Spacer()
                            Text("\(tx.quantity.formatted()) @ \(tx.price.formatted())")
                                .monospacedDigit()
                        }
                    }
                }
            }

            Section("价格走势") {
                Text("待接入 PriceSnapshot 折线图").foregroundStyle(.secondary)
            }
        }
        .navigationTitle(holding.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { /* TODO: 记录交易 / 编辑持仓 */ } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
