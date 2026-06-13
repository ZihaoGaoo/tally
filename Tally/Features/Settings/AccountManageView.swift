import SwiftUI
import SwiftData

/// 账户管理：维护账户与期初余额（首启 onboarding 复用）。
struct AccountManageView: View {
    @Query(sort: \Account.sortOrder) private var accounts: [Account]

    var body: some View {
        Group {
            if accounts.isEmpty {
                EmptyStateView(
                    systemImage: "creditcard",
                    message: "添加你的账户并填写期初余额"
                )
            } else {
                List {
                    // TODO: 当前余额 = 期初 + Σ流水；新增/编辑/归档账户。
                    ForEach(accounts) { account in
                        HStack {
                            Text(account.name)
                            Spacer()
                            Text(account.type.title)
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("账户管理")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { /* TODO: 新增账户 */ } label: { Image(systemName: "plus") }
            }
        }
    }
}

#Preview {
    NavigationStack { AccountManageView() }
        .modelContainer(AppSchema.previewContainer)
}
