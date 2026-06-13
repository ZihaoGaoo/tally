import SwiftUI

/// 日常账本统计：分类占比、收支趋势、排行榜、同环比。
struct StatisticsView: View {
    @Binding var period: StatPeriod

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PeriodPicker(selection: $period)

                // TODO: 接入 Swift Charts。
                placeholder("消费分类占比（饼图）")
                placeholder("每日收支趋势（柱状图）")
                placeholder("分类排行榜 / 账单排行榜")
                placeholder("账户维度统计")
                placeholder("同环比卡片")
            }
            .padding()
        }
    }

    private func placeholder(_ title: String) -> some View {
        SummaryCard(title: title) {
            Text("待实现")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 80)
        }
    }
}

#Preview {
    StatisticsView(period: .constant(.month))
}
