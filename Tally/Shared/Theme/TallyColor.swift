import SwiftUI

/// 语义配色。颜色不作为唯一信息传达手段，需配合图标/文字。
extension Color {
    /// 主题色（FAB、主按钮、Tab 选中）。
    static let tallyAccent = Color.blue
    /// 支出 / 投资浮亏 / 净债务（橙）—— 见各处具体语义。
    static let tallyExpense = Color.red
    /// 收入 / 投资浮盈 / 净债权。
    static let tallyIncome = Color.green
    static let tallyProfit = Color.green
    static let tallyLoss = Color.red
    static let tallyCredit = Color.green
    static let tallyDebt = Color.orange
    /// 警告（价格过期、即将到期）。
    static let tallyWarning = Color.orange

    /// 从 `#RRGGBB` 十六进制字符串构造颜色。
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r = Double((value & 0xFF0000) >> 16) / 255
        let g = Double((value & 0x00FF00) >> 8) / 255
        let b = Double(value & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
