import SwiftUI

/// 设置：安全、币种、同步、各类管理入口、数据导入导出。
struct SettingsView: View {
    @AppStorage("faceIDLock") private var faceIDLock = false
    @AppStorage("iCloudSync") private var iCloudSync = false

    var body: some View {
        List {
            Section("安全") {
                Toggle("Face ID 应用锁", isOn: $faceIDLock)
            }
            Section("数据") {
                Toggle("iCloud 同步", isOn: $iCloudSync)
                NavigationLink("账户管理") { AccountManageView() }
                NavigationLink("分类管理") { CategoryManageView() }
                NavigationLink("平台管理") { PlatformManageView() }
                // TODO: 多币种 / 汇率配置、CSV 导入导出。
                Text("数据导入导出 (CSV)").foregroundStyle(.secondary)
            }
            Section {
                LabeledContent("版本", value: "0.1.0")
            }
        }
        .navigationTitle("设置")
    }
}

#Preview {
    NavigationStack { SettingsView() }
}
