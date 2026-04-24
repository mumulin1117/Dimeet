//
//  MiwcitrusZestCore.swift
//  DoinDiSieied
//
//  Created by DoinDiSieied on 2026/4/24.
//

import UIKit
//网络请求管理
class MiwcitrusZestCore: NSObject {
    
     
    static let shared = MiwcitrusZestCore()
    internal override init() {
            super.init()
        }
    // MARK: - 通用网络请求（POST）
    func GMTAvalidatorCheckItem(
        _ path: String,
                GMTAsanitizerCleanJob: [String: Any],
                GMTAiformatterStyleSet: Bool = false,
                GMTAdisplayViewRoot: @escaping (Result<[String: Any]?, Error>) -> Void = { _ in }
    ) {
        
        // 1. 生成 URL
        guard let GMTAlayoutMarginSpace = URL(string: VsimmerPacePart.scentDiffuserSet.GMTAcacheData + path) else {
            return         GMTAdisplayViewRoot(.failure(NSError(domain: DramngredientNod.GMTA34, code: 400)))
        }
        
        // 2. 参数 → JSON → AES 加密
        guard let GMTApaddingInnerSize = MiwcitrusZestCore.GMTAjcontentSizeDim(GMTAinsetTopVal:         GMTAsanitizerCleanJob),
              let GMTAborderWidthLine = ADeTpacketLossMask(),
              let GMTAcornerRadiusArc = GMTAborderWidthLine.GMTAcalorieCountStub(GMTApaddingInnerSize),
              let GMTAshadowOffsetPos = GMTAcornerRadiusArc.data(using: .utf8) else {
            return
        }
        
        // 3. 创建 URLRequest
        var GMTAopacityAlphaVal = URLRequest(url: GMTAlayoutMarginSpace)
        GMTAopacityAlphaVal.httpMethod = DramngredientNod.GMTA35
        GMTAopacityAlphaVal.httpBody = GMTAshadowOffsetPos
        GMTAopacityAlphaVal.timeoutInterval = 15
        GMTAopacityAlphaVal.setValue(DramngredientNod.GMTA39, forHTTPHeaderField: DramngredientNod.GMTA36)
        GMTAopacityAlphaVal.setValue(VsimmerPacePart.scentDiffuserSet.GMTArecordSet, forHTTPHeaderField: DramngredientNod.GMTA37)
        GMTAopacityAlphaVal.setValue(Bundle.main.GMTAinsetLeftVal, forHTTPHeaderField: DramngredientNod.GMTA38)
        GMTAopacityAlphaVal.setValue(EvryasteBudsElement.GMTAfilterCutoffPoint(), forHTTPHeaderField: DramngredientNod.GMTA40)
        GMTAopacityAlphaVal.setValue(Locale.current.languageCode ?? "", forHTTPHeaderField: DramngredientNod.GMTA41)
        GMTAopacityAlphaVal.setValue(UserDefaults.standard.string(forKey: DramngredientNod.GMTA62 ) ?? "", forHTTPHeaderField: DramngredientNod.GMTA42)
        GMTAopacityAlphaVal.setValue(UserDefaults.standard.string(forKey: DramngredientNod.GMTA61) ?? "", forHTTPHeaderField: DramngredientNod.GMTA43)
        
        // 4. 发送请求
        let GMTAhiddenStateBool = URLSession.shared.dataTask(with: GMTAopacityAlphaVal) { data, response, error in
            
            // 网络错误
            if let GMTAclipBoundsArea = error {
                DispatchQueue.main.async {         GMTAdisplayViewRoot(.failure(GMTAclipBoundsArea)) }
                return
            }
            
            guard let GMTAmaskLayerRef = data else {
                DispatchQueue.main.async {
                            GMTAdisplayViewRoot(.failure(NSError(domain: DramngredientNod.GMTA44, code: 1000)))
                }
                return
            }
            
            self.GMTAgradientColorStop(
                GMTAtextDecorationLine:         GMTAiformatterStyleSet,
                GMTAimageSour: GMTAmaskLayerRef,
                GMTAeightHeavy: path,
                GMTAletterSpaceGap:         GMTAdisplayViewRoot
            )
        }
        
        GMTAhiddenStateBool.resume()
    }

    
    // MARK: - 解析返回数据
    private func GMTAgradientColorStop(
        GMTAtextDecorationLine: Bool = false,
        GMTAimageSour: Data,
        GMTAeightHeavy: String,
        GMTAletterSpaceGap: @escaping (Result<[String: Any]?, Error>) -> Void
    ) {
        do {
            // 原始 JSON
            guard let GMTAtextAlignEdge = try JSONSerialization.jsonObject(with: GMTAimageSour) as? [String: Any] else {
                throw NSError(domain: DramngredientNod.GMTA45, code: 1001)
            }
            
            print("--------request reust--------")
            print(GMTAtextAlignEdge)
            
            // 支付类不解析 result，只判定 code
            if GMTAtextDecorationLine {
                guard let GMTAlineBreakMode = GMTAtextAlignEdge[DramngredientNod.GMTA46] as? String, GMTAlineBreakMode == DramngredientNod.GMTA47 else {
                    DispatchQueue.main.async {
                        GMTAletterSpaceGap(.failure(NSError(domain: DramngredientNod.GMTA48, code: 1001)))
                    }
                    return
                }
                DispatchQueue.main.async { GMTAletterSpaceGap(.success([:])) }
                return
            }

            // 普通接口需要解密 result
            guard let GMTAtruncationStyle = GMTAtextAlignEdge[DramngredientNod.GMTA46] as? String, GMTAtruncationStyle == DramngredientNod.GMTA47,
                  let GMTAencryptedResult = GMTAtextAlignEdge[DramngredientNod.GMTA49] as? String else {
                throw NSError(domain: GMTAtextAlignEdge[DramngredientNod.GMTA50] as? String ?? DramngredientNod.GMTA51, code: 1002)
            }

            // AES 解密
            guard let GMTAkeyboardTypeKey = ADeTpacketLossMask(),
                  let GMTAdecelerationDecel = GMTAkeyboardTypeKey.GMTAfiberContentLeaf(hydrationFlowNode: GMTAencryptedResult),
                  let GMTAdragVelocityVec = GMTAdecelerationDecel.data(using: .utf8),
                  let GMTAcontentOffsetPos = try JSONSerialization.jsonObject(with: GMTAdragVelocityVec) as? [String: Any] else {
                throw NSError(domain: DramngredientNod.GMTA52, code: 1003)
            }
            
            DispatchQueue.main.async {
                GMTAletterSpaceGap(.success(GMTAcontentOffsetPos))
            }
            
        } catch {
            DispatchQueue.main.async {
                GMTAletterSpaceGap(.failure(error))
            }
        }
    }

    
    // MARK: - Dictionary → JSON String
    class func GMTAjcontentSizeDim(GMTAinsetTopVal dict: [String: Any]) -> String? {
        guard let insetBottomVal = try? JSONSerialization.data(withJSONObject: dict) else { return nil }
        return String(data: insetBottomVal, encoding: .utf8)
    }
}


private extension Bundle {
    var GMTAinsetLeftVal: String {
        object(forInfoDictionaryKey: DramngredientNod.GMTA53) as? String ?? ""
    }
}





