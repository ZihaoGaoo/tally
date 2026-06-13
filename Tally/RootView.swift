import SwiftUI

/// 应用根视图：底部 4 个固定 Tab + 全局快速记账 FAB。
struct RootView: View {
    enum Tab: Hashable {
        case overview, ledger, investment, credit
    }

    @State private var selection: Tab = .overview
    @State private var showQuickEntry = false
    @State private var showQuickMenu = false

    var body: some View {
        TabView(selection: $selection) {
            OverviewView()
                .tabItem { Label("总览", systemImage: "chart.pie.fill") }
                .tag(Tab.overview)

            LedgerView()
                .tabItem { Label("账本", systemImage: "list.bullet.rectangle.fill") }
                .tag(Tab.ledger)

            PortfolioView()
                .tabItem { Label("投资", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(Tab.investment)

            CreditListView()
                .tabItem { Label("信用", systemImage: "person.2.fill") }
                .tag(Tab.credit)
        }
        .tint(.tallyAccent)
        .overlay(alignment: .bottom) { quickAddButton }
        .sheet(isPresented: $showQuickEntry) {
            QuickEntrySheet()
        }
        .confirmationDialog("快速记一笔", isPresented: $showQuickMenu, titleVisibility: .visible) {
            // TODO: 各入口跳转对应模块的快速录入表单
            Button("记支出") { showQuickEntry = true }
            Button("记收入") { showQuickEntry = true }
            Button("转账") { showQuickEntry = true }
            Button("记投资") { selection = .investment }
            Button("记欠款") { selection = .credit }
            Button("记别人欠我") { selection = .credit }
            Button("取消", role: .cancel) {}
        }
    }

    /// 悬浮在 TabBar 上方的快速记账按钮：点击快速记一笔，长按弹出多模块菜单。
    private var quickAddButton: some View {
        Button {
            showQuickEntry = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 48))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color.tallyAccent)
                .background(Circle().fill(.white).padding(6))
                .shadow(radius: 4, y: 2)
        }
        .accessibilityLabel("记一笔")
        .simultaneousGesture(LongPressGesture().onEnded { _ in showQuickMenu = true })
        .offset(y: -28)
    }
}

#Preview {
    RootView()
        .modelContainer(AppSchema.previewContainer)
}
