import Foundation

/// 行情报价。
struct PriceQuote {
    let symbol: String
    let price: Decimal
    let currency: String
    var change: Decimal?
    var changePercent: Decimal?
    let timestamp: Date
    let source: String
}

/// 行情接入错误。
enum PriceProviderError: Error {
    case symbolNotFound(String)
    case rateLimitExceeded
    case networkUnavailable
    case invalidResponse
    case authenticationFailed
    case assetClassNotSupported
}

/// 行情数据源抽象协议，使各资产类别的数据源可插拔、可替换。
/// 详见 docs/api-integration.md。
protocol PriceProvider {
    func fetchQuote(symbol: String, assetClass: AssetClass) async throws -> PriceQuote
    func fetchQuotes(symbols: [(symbol: String, assetClass: AssetClass)]) async throws -> [PriceQuote]
    var supportedAssetClasses: Set<AssetClass> { get }
}

/// MVP 默认实现：手动录入价格，不发起网络请求。
struct ManualPriceProvider: PriceProvider {
    var supportedAssetClasses: Set<AssetClass> { Set(AssetClass.allCases) }

    func fetchQuote(symbol: String, assetClass: AssetClass) async throws -> PriceQuote {
        // 手动模式下不提供自动报价。
        throw PriceProviderError.assetClassNotSupported
    }

    func fetchQuotes(symbols: [(symbol: String, assetClass: AssetClass)]) async throws -> [PriceQuote] {
        []
    }
}

/// 按资产类别路由到对应 Provider 的调度器（骨架）。
final class PriceProviderRegistry {
    private var providers: [AssetClass: PriceProvider] = [:]

    func register(_ provider: PriceProvider, for assetClasses: Set<AssetClass>) {
        for assetClass in assetClasses {
            providers[assetClass] = provider
        }
    }

    func fetchQuote(symbol: String, assetClass: AssetClass) async throws -> PriceQuote {
        guard let provider = providers[assetClass] else {
            throw PriceProviderError.assetClassNotSupported
        }
        return try await provider.fetchQuote(symbol: symbol, assetClass: assetClass)
    }

    // TODO: fetchAllHoldings —— 按 assetClass 分组并发请求，含 60s 节流与降级。
}
