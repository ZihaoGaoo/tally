import SwiftUI

/// 总览页/各模块顶部的摘要卡片。
struct SummaryCard<Content: View>: View {
    let title: String
    var trailingValue: String? = nil
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                if let trailingValue {
                    Text(trailingValue)
                        .font(.headline)
                        .monospacedDigit()
                }
            }
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    SummaryCard(title: "净资产", trailingValue: "¥ 128,450.00") {
        Text("较上月 ▲ ¥3,200 (+2.5%)")
            .font(.caption)
            .foregroundStyle(.green)
    }
    .padding()
}
