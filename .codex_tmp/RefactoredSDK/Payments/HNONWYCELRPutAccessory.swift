import Foundation
import StoreKit

final class HNONWYCELRPutAccessory: NSObject {
    static let shared = HNONWYCELRPutAccessory()

    var HNONWYCELRfabricsculpt: String?

    private var HNONWYCELRcompletion: ((Result<Void, Error>) -> Void)?
    private var HNONWYCELRrequest: SKProductsRequest?

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func HNONWYCELRtexturemapping(
        HNONWYCELRseasonalstyling productID: String,
        HNONWYCELRpalettecraft: @escaping (Result<Void, Error>) -> Void
    ) {
        guard SKPaymentQueue.canMakePayments() else {
            DispatchQueue.main.async {
                HNONWYCELRpalettecraft(.failure(APPPREFIXPurchaseErrorFactory.make(
                    message: TgextileLuster.shared.APPPREFIX_messages.purchaseDisabledMessage,
                    code: -1
                )))
            }
            return
        }

        HNONWYCELRcompletion = HNONWYCELRpalettecraft
        HNONWYCELRrequest?.cancel()
        let request = SKProductsRequest(productIdentifiers: [productID])
        request.delegate = self
        HNONWYCELRrequest = request
        request.start()
    }

    func HNONWYCELRfabricdraping() -> Data? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return nil }
        return try? Data(contentsOf: receiptURL)
    }
}

extension HNONWYCELRPutAccessory: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            DispatchQueue.main.async {
                self.HNONWYCELRcompletion?(.failure(APPPREFIXPurchaseErrorFactory.make(
                    message: TgextileLuster.shared.APPPREFIX_messages.missingProductMessage,
                    code: -2
                )))
                self.HNONWYCELRcompletion = nil
            }
            return
        }

        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.HNONWYCELRcompletion?(.failure(error))
            self.HNONWYCELRcompletion = nil
        }
    }
}

extension HNONWYCELRPutAccessory: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:
                HNONWYCELRfabricsculpt = transaction.transactionIdentifier
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.HNONWYCELRcompletion?(.success(()))
                    self.HNONWYCELRcompletion = nil
                }

            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                let error: Error
                if (transaction.error as? SKError)?.code == .paymentCancelled {
                    error = APPPREFIXPurchaseErrorFactory.make(
                        message: TgextileLuster.shared.APPPREFIX_messages.paymentCancelledMessage,
                        code: -999
                    )
                } else {
                    error = transaction.error ?? APPPREFIXPurchaseErrorFactory.make(
                        message: TgextileLuster.shared.APPPREFIX_messages.transactionFailedMessage,
                        code: -3
                    )
                }

                DispatchQueue.main.async {
                    self.HNONWYCELRcompletion?(.failure(error))
                    self.HNONWYCELRcompletion = nil
                }

            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)

            default:
                break
            }
        }
    }
}

private enum APPPREFIXPurchaseErrorFactory {
    static func make(message: String, code: Int) -> NSError {
        NSError(domain: "Honiy", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
