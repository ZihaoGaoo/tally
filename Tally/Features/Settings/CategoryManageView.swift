import SwiftUI
import SwiftData

/// 分类管理：维护支出/收入分类（图标 + 颜色 + 排序）。
struct CategoryManageView: View {
    @Query(sort: \Category.sortOrder) private var categories: [Category]

    var body: some View {
        Group {
            if categories.isEmpty {
                EmptyStateView(systemImage: "square.grid.2x2", message: "暂无分类，添加一个吧")
            } else {
                List {
                    // TODO: 新增/隐藏/排序（长按拖拽）；预置分类不可删除。
                    ForEach(categories) { category in
                        Label(category.name, systemImage: category.sfSymbol)
                            .foregroundStyle(Color(hex: category.colorHex))
                    }
                }
            }
        }
        .navigationTitle("分类管理")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { /* TODO: 新增分类 */ } label: { Image(systemName: "plus") }
            }
        }
    }
}

#Preview {
    NavigationStack { CategoryManageView() }
        .modelContainer(AppSchema.previewContainer)
}
