import SwiftUI

/// 统计时间段。
enum StatPeriod: String, CaseIterable, Identifiable {
    case week, month, year, custom
    var id: String { rawValue }
    var title: String {
        switch self {
        case .week: return "周"
        case .month: return "月"
        case .year: return "年"
        case .custom: return "自定义"
        }
    }
}

/// 时间段选择器（胶囊形 Segmented）。自定义区间选择待实现。
struct PeriodPicker: View {
    @Binding var selection: StatPeriod

    var body: some View {
        Picker("时间段", selection: $selection) {
            ForEach(StatPeriod.allCases) { period in
                Text(period.title).tag(period)
            }
        }
        .pickerStyle(.segmented)
        // TODO: .custom 时弹出 DateRangePicker；月/周左右翻页与手势切换。
    }
}

#Preview {
    PeriodPicker(selection: .constant(.month)).padding()
}
