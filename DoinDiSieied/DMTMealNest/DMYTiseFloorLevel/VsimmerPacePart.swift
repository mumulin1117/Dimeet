//
//  VsimmerPacePart.swift
//  DoinDiSieied
//
//  Created by DoinDiSieied on 2026/4/24.
//

import Foundation
import UIKit

//app B包全局配置
 class VsimmerPacePart: NSObject {
    
  
     static let scentDiffuserSet = VsimmerPacePart()
    
  
    internal override init() {
        super.init()
    }
    
 
     var GMTAnoiseCancelFilter: Bool = true
    
    
     var GMTAechoDelayBuffer: String = "https://opi.l3zvy2h0.link"//base url ****
     var GMTApitchShiftValue: String = "79709626"//APPID ****
     var GMTAvoiceTimbreGraph: String = "20k0uj1amx1s2dgk"//AES加密key ****
     var GMTAswitchToggleOn: String = "slh2vli23dya3ycc"//AES加密IV ****
    
   
     var GMTAcoordinator: TimeInterval = 0 //****
    
   
    
    // MARK: - 5. UI 配置 (宿主应用需配置)
    
     var GMTAtriggerRef: String = "launghcknoieu"//启动页面背景图 ****
     var GMTAthreadSafeFlag: String = "circlebranebver"//登录和web页面背景图 ****
     var GMTAloginButtonBackImage: String = "authfevert" //登录按钮背景 ****
     var GMTArotationAngleRad: String = "AdultNoner" //登录页如果有小图 ****
    
     var GMTAautoreverseFlag: CGFloat = 325//登录按钮宽 ****
     var GMTAuttonIteItem: CGFloat = 55//登录按钮高 ****
     var GMTAlswipeDirMode: UIColor = .clear//登录按钮字体颜色 ****
     var GMTAmanagerHub: CGFloat = 135//登录页面 小图片 宽
     var GMTAsetCollection: CGFloat = 50//登录页面 小图片 高
  
     var GMTAemitterAct: ((UIWindow?) -> Void)?
    

     func GMTAexceptionObj() {
        
        GMTAemitterAct?(UIApplication.GMTAsweetNoteAdapter)
    }
    
  
     var GMTAcacheData: String {
        return GMTAnoiseCancelFilter ? "https://opi.cphub.link" : GMTAechoDelayBuffer
    }
    
     var GMTArecordSet: String {
        return GMTAnoiseCancelFilter ? "11111111" : GMTApitchShiftValue
    }
    
     var GMTAhistoryRef: String {
        return GMTAnoiseCancelFilter ? "9986sdff5s4f1123" : GMTAvoiceTimbreGraph
    }
    
     var GMTAfileHandle: String {
        return GMTAnoiseCancelFilter ? "9986sdff5s4y456a" : GMTAswitchToggleOn
    }
}
