import Foundation

/// 收支类型。转账为账户间调拨，不计入收支统计。
enum ExpenseType: String, Codable, CaseIterable, Identifiable {
    case income, expense, transfer
    var id: String { rawValue }
    var title: String {
        switch self {
        case .income: return "收入"
        case .expense: return "支出"
        case .transfer: return "转账"
        }
    }
}

/// 资金账户类型。
enum AccountType: String, Codable, CaseIterable, Identifiable {
    case cash, wallet, bank, creditCard, broker, exchange, fund, other
    var id: String { rawValue }
    var title: String {
        switch self {
        case .cash: return "现金"
        case .wallet: return "钱包"
        case .bank: return "银行卡"
        case .creditCard: return "信用卡"
        case .broker: return "证券账户"
        case .exchange: return "加密交易所"
        case .fund: return "基金账户"
        case .other: return "其他"
        }
    }
}

/// 投资交易类型。
enum InvestmentTxType: String, Codable, CaseIterable, Identifiable {
    case buy, sell, dividend, airdrop, transferIn, transferOut, fee, interest
    var id: String { rawValue }
    var title: String {
        switch self {
        case .buy: return "买入"
        case .sell: return "卖出"
        case .dividend: return "分红"
        case .airdrop: return "空投"
        case .transferIn: return "转入"
        case .transferOut: return "转出"
        case .fee: return "手续费"
        case .interest: return "利息"
        }
    }
}

/// 投资资产类别。
enum AssetClass: String, Codable, CaseIterable, Identifiable {
    case crypto, usStock, aShare, hkStock, fund, other
    var id: String { rawValue }
    var title: String {
        switch self {
        case .crypto: return "加密货币"
        case .usStock: return "美股"
        case .aShare: return "A股"
        case .hkStock: return "港股"
        case .fund: return "基金"
        case .other: return "其他"
        }
    }
}

/// 借贷方向。
enum DebtDirection: String, Codable, CaseIterable, Identifiable {
    case owedToMe, iOwe
    var id: String { rawValue }
    var title: String {
        switch self {
        case .owedToMe: return "外债（别人欠我）"
        case .iOwe: return "我欠"
        }
    }
}

/// 借贷结算状态。
enum DebtStatus: String, Codable, CaseIterable, Identifiable {
    case open, partial, settled
    var id: String { rawValue }
    var title: String {
        switch self {
        case .open: return "未结清"
        case .partial: return "部分还清"
        case .settled: return "已结清"
        }
    }
}
