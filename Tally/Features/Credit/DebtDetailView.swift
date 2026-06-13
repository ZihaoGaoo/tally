import SwiftUI

/// 借贷详情：基本信息 + 还款时间线 + 记录还款 + 到期提醒。
struct DebtDetailView: View {
    let debt: Debt

    var body: some View {
        List {
            Section {
                LabeledContent("方向", value: debt.direction.title)
                LabeledContent("总金额", value: debt.amount.formatted())
                LabeledContent("已还", value: debt.settledAmount.formatted())
                LabeledContent("剩余", value: debt.remainingAmount.formatted())
                LabeledContent("状态", value: debt.status.title)
                if let dueDate = debt.dueDate {
                    LabeledContent("到期", value: dueDate.formatted(date: .numeric, time: .omitted))
                }
                if debt.isInstallment, let count = debt.installmentCount {
                    LabeledContent("分期", value: "\(count) 期")
                }
            }

            Section("还款记录") {
                if debt.repayments.isEmpty {
                    Text("暂无还款").foregroundStyle(.secondary)
                } else {
                    ForEach(debt.repayments) { rp in
                        HStack {
                            Text(rp.date.formatted(date: .numeric, time: .omitted))
                            Spacer()
                            Text(rp.amount.formatted()).monospacedDigit()
                        }
                    }
                }
            }
        }
        .navigationTitle(debt.counterparty.name)
        .safeAreaInset(edge: .bottom) {
            Button {
                // TODO: 弹出 RepaymentSheet（金额/日期/账户），更新 settledAmount 与 status。
            } label: {
                Text("记录一笔还款")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}
