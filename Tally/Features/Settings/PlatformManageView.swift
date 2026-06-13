import SwiftUI
import SwiftData

/// 平台管理：维护投资平台。
struct PlatformManageView: View {
    @Query(sort: \Platform.sortOrder) private var platforms: [Platform]

    var body: some View {
        Group {
            if platforms.isEmpty {
                EmptyStateView(systemImage: "building.columns", message: "暂无平台，添加一个吧")
            } else {
                List {
                    // TODO: 新增/编辑平台；预置平台不可删除。
                    ForEach(platforms) { platform in
                        Text(platform.name)
                    }
                }
            }
        }
        .navigationTitle("平台管理")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { /* TODO: 新增平台 */ } label: { Image(systemName: "plus") }
            }
        }
    }
}

#Preview {
    NavigationStack { PlatformManageView() }
        .modelContainer(AppSchema.previewContainer)
}
