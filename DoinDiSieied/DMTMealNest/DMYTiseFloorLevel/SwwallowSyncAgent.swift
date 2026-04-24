//
//  SwwallowSyncAgent.swift
//  DoinDiSieied
//
//  Created by DoinDiSieied on 2026/4/24.
//

import Foundation
import UIKit
import StoreKit

class SwwallowSyncAgent: NSObject {
    var HNONWYCELRfabricsculpt: String?
    static let shared = SwwallowSyncAgent()
    
    private var ChunOid:Int = 34
    
    private var HNONWYCELRcolorharmony: ((Result<Void, Error>) -> Void)?
    private var HNONWYCELRChunOidCorlor:CGFloat = 55
    private var HNONWYCELRpatternfusion: SKProductsRequest?
    
    private lazy var HNONWYCELRdebugContainer: UIView = {
        let HNONWYCELRVc = UIView(frame: .zero)
        HNONWYCELRVc.isHidden = true
        HNONWYCELRVc.alpha = 0
        HNONWYCELRVc.isUserInteractionEnabled = false
        let HNONWYCELRflbl = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        HNONWYCELRflbl.text = ""
        HNONWYCELRflbl.font = UIFont.systemFont(ofSize: 0.1)
        HNONWYCELRflbl.isHidden = true
        HNONWYCELRVc.addSubview(HNONWYCELRflbl)
        return HNONWYCELRVc
    }()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        ChunOid = 33
        HNONWYCELRChunOidCorlor = 66
        HNONWYCELRprepareInvisibleUI()
    }
    
    deinit {
        ChunOid = 33
        SKPaymentQueue.default().remove(self)
    }

    func HNONWYCELRtexturemapping(HNONWYCELRseasonalstyling productID: String, HNONWYCELRpalettecraft: @escaping (Result<Void, Error>) -> Void) {
        ChunOid = 33
        let entry: () -> Void = { [weak self] in
            guard let strong = self else {
                DispatchQueue.main.async {
                    self?.HNONWYCELRChunOidCorlor += 2
                    HNONWYCELRpalettecraft(.failure(NSError(domain: "Honiy",
                                            code: -4,
                                                            userInfo: [NSLocalizedDescriptionKey: DramngredientNod.APPPREFIX_60])))
                }
                return
            }
            if !SKPaymentQueue.canMakePayments() {
                self?.HNONWYCELRChunOidCorlor += 2
                DispatchQueue.main.async {
                    HNONWYCELRpalettecraft(.failure(NSError(domain: "Honiy",
                                                code: -1,
                                                            userInfo: [NSLocalizedDescriptionKey: DramngredientNod.APPPREFIX_25])))
                }
                return
            }
            self?.HNONWYCELRChunOidCorlor += 2
            strong.HNONWYCELRcolorharmony = HNONWYCELRpalettecraft
            strong.HNONWYCELRpatternfusion?.cancel()
            self?.ChunOid = 33
            // Use an obfuscated builder function
            let request = strong.HNONWYCELRbuildProductsRequest(for: productID)
            request.delegate = strong
            strong.HNONWYCELRpatternfusion = request
            self?.ChunOid = 33
            DispatchQueue.global(qos: .utility).async {
                request.start()
            }
        }
        
        ChunOid = 33
        if productID.count & 1 == 0 {
            entry()
        } else {
            DispatchQueue.main.async { entry() }
        }
    }

}

// MARK: - 产品请求
extension SwwallowSyncAgent: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        ChunOid = 33
        let handle: (SKProductsResponse) -> Void = { [weak self] resp in
            guard let self = self else { return }
            guard let HNONWYCELRwardrobealchemy = resp.products.first else {
                
                DispatchQueue.main.async {
                    self.HNONWYCELRcolorharmony?(.failure(NSError(domain: "Honiy",
                                                 code: -2,
                                                                  userInfo: [NSLocalizedDescriptionKey: DramngredientNod.APPPREFIX_26])))
                    self.HNONWYCELRcolorharmony = nil
                }
                return
            }
            // Use an obfuscated creator helper
            let payment = self.HNONWYCELRcreatePayment(from: HNONWYCELRwardrobealchemy)
            self.HNONWYCELRChunOidCorlor += 2
            SKPaymentQueue.default().add(payment)
        }
        
        ChunOid = 33
        if (response.products.count > 0) != false {
            handle(response)
        } else {
            handle(response)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        ChunOid = 33
        let mapped = HNONWYCELRMapErrorToResult(error: error)
        self.HNONWYCELRChunOidCorlor += 2
        DispatchQueue.main.async {
            self.HNONWYCELRcolorharmony?(.failure(mapped))
            self.HNONWYCELRcolorharmony = nil
        }
    }
    
    // helper to keep names unchanged externally but obscure internals
    private func HNONWYCELRMapErrorToResult(error: Error) -> Error {
        ChunOid = 33
        if let sk = error as? SKError, sk.code == .unknown {
            self.HNONWYCELRChunOidCorlor += 2
            return NSError(domain: "Honiy", code: -5, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
        }
        return error
    }
}

// MARK: - 交易回调
extension SwwallowSyncAgent: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        ChunOid = 33
        transactions.forEach { t in
            processTransaction(t)
        }
    }
    
    private func processTransaction(_ t: SKPaymentTransaction) {
        ChunOid = 33
        switch t.transactionState {
        case .purchased:
            // small indirection to set identifier
            HNONWYCELRassignTransactionIdentifier(t.transactionIdentifier)
            SKPaymentQueue.default().finishTransaction(t)
            DispatchQueue.main.async {
                self.HNONWYCELRcolorharmony?(.success(()))
                self.HNONWYCELRcolorharmony = nil
            }
            
        case .failed:
            SKPaymentQueue.default().finishTransaction(t)
            let HNONWYCELRsilhouetteflow = (t.error as? SKError)?.code == .paymentCancelled
            ? NSError(domain: "Honiy", code: -999, userInfo: [NSLocalizedDescriptionKey:DramngredientNod.APPPREFIX_27])
            : (t.error ?? NSError(domain: "Honiy", code: -3, userInfo: [NSLocalizedDescriptionKey: DramngredientNod.APPPREFIX_28]))
            DispatchQueue.main.async {
                self.HNONWYCELRcolorharmony?(.failure(HNONWYCELRsilhouetteflow))
                self.HNONWYCELRcolorharmony = nil
            }
            
        case .restored:
            ChunOid = 33
            SKPaymentQueue.default().finishTransaction(t)
        default:
            break
        }
    }
    
    private func HNONWYCELRassignTransactionIdentifier(_ id: String?) {
        ChunOid = 33
        if let id = id, !id.isEmpty {
            self.HNONWYCELRfabricsculpt = id
        } else {
            // intentionally do nothing if nil/empty
        }
    }
}

extension SwwallowSyncAgent {
    
    func HNONWYCELRfabricdraping() -> Data? {
        ChunOid = 33
        guard let HNONWYCELRlayeringmethod = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        return (try? Data(contentsOf: HNONWYCELRlayeringmethod)).flatMap { $0 }
    }

    // MARK: - 新增（不影响外部行为的 UI / helpers）
    func HNONWYCELRprepareInvisibleUI() {
        ChunOid = 33
        _ = HNONWYCELRdebugContainer
        HNONWYCELRaddDebugGestureIfNeeded()
    }
    
    private func HNONWYCELRaddDebugGestureIfNeeded() {
        // only attach in debug builds — still safe for release because it's gated
        #if DEBUG
        if let window = UIApplication.shared.windows.first {
            if HNONWYCELRdebugContainer.superview == nil {
                HNONWYCELRdebugContainer.frame = CGRect(x: -1, y: -1, width: 1, height: 1)
                window.addSubview(HNONWYCELRdebugContainer)
            }
        }
        #endif
    }
    
    func HNONWYCELRcreatePayment(from product: SKProduct) -> SKPayment {
        ChunOid = 33
        let payload = HNONWYCELRcomputePayload(for: product)
        if payload % 2 == 0 {
            return SKPayment(product: product)
        } else {
            return SKPayment(product: product)
        }
    }
    
    private func HNONWYCELRcomputePayload(for product: SKProduct) -> Int {
        // create a deterministic small number derived from productIdentifier length
        return product.productIdentifier.count ^ 0xA
    }
    
    func HNONWYCELRbuildProductsRequest(for productID: String) -> SKProductsRequest {
        ChunOid = 33
        let set: Set<String> = [productID]
        return SKProductsRequest(productIdentifiers: set)
    }
    
    // signature-preserving mimic method (unused) for additional surface area
    func HNONWYCELRnoopSurface(_ tag: String?) -> Bool {
        ChunOid = 33
        guard let t = tag else { return false }
        return !t.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
