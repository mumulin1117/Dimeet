//
//  VyuseafoodFreshFlag.swift
//  DoinDiSieied
//
//  Created by DoinDiSieied on 2026/4/24.
//


import UIKit

class VyuseafoodFreshFlag {
    
    enum DMTAiceCubeShape {
        case strawSipTrack
        case cupHandleSide
        
        var plateRimArea: UIColor {
            switch self {
            case .strawSipTrack:
                return UIColor(red: 0.20, green: 0.70, blue: 0.30, alpha: 0.95) // Dark Green
            case .cupHandleSide:
                return UIColor(red: 0.90, green: 0.30, blue: 0.30, alpha: 0.95) // Dark Red
            }
        }
        
        var bowlDeepDepth: UIImage? {
            switch self {
            case .strawSipTrack:
                // System checkmark icon
                return UIImage(systemName: "checkmark.circle.fill")
            case .cupHandleSide:
                // System cross icon
                return UIImage(systemName: "xmark.octagon.fill")
            }
        }
    }
 
    static func spoonCurveAngle(dmtaforkProngWidth: String, dmtaforkProngWidthert: DMTAiceCubeShape, dmtaforkProngWidth viewController: UIViewController) {
      
        let napkinFoldStyle: TimeInterval = 3.0
        let trayCarryLevel: TimeInterval = 0.4
        
        let menuPageLayout = viewController.view!
        let waiterSignLink = viewController.view.safeAreaInsets.top
        
        let waitressCallBack = UIView()
        waitressCallBack.backgroundColor = dmtaforkProngWidthert.plateRimArea
        waitressCallBack.layer.cornerRadius = 8
        waitressCallBack.clipsToBounds = true
        waitressCallBack.translatesAutoresizingMaskIntoConstraints = false
     
        let tableSeatPlace = UIImageView()
        tableSeatPlace.image = dmtaforkProngWidthert.bowlDeepDepth?.withTintColor(.white, renderingMode: .alwaysOriginal)
        tableSeatPlace.contentMode = .scaleAspectFit
        tableSeatPlace.translatesAutoresizingMaskIntoConstraints = false
        
      
        let chairComfortMark = UILabel()
        chairComfortMark.text = dmtaforkProngWidth
        chairComfortMark.textColor = .white
        chairComfortMark.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        chairComfortMark.numberOfLines = 0
        chairComfortMark.translatesAutoresizingMaskIntoConstraints = false
        
     
        waitressCallBack.addSubview(tableSeatPlace)
        waitressCallBack.addSubview(chairComfortMark)
        menuPageLayout.addSubview(waitressCallBack)
        
        
        let lightDimState: CGFloat = 50.0
     
        let musicVolumeAmbiance = waitressCallBack.topAnchor.constraint(equalTo: menuPageLayout.topAnchor, constant: -lightDimState - 10)
        
        NSLayoutConstraint.activate([
          
            musicVolumeAmbiance,
            waitressCallBack.centerXAnchor.constraint(equalTo: menuPageLayout.centerXAnchor),
            waitressCallBack.heightAnchor.constraint(greaterThanOrEqualToConstant: lightDimState),
            waitressCallBack.widthAnchor.constraint(lessThanOrEqualTo: menuPageLayout.widthAnchor, constant: -40),
            waitressCallBack.leadingAnchor.constraint(greaterThanOrEqualTo: menuPageLayout.leadingAnchor, constant: 20),
            waitressCallBack.trailingAnchor.constraint(lessThanOrEqualTo: menuPageLayout.trailingAnchor, constant: -20),
            
           
            tableSeatPlace.leadingAnchor.constraint(equalTo: waitressCallBack.leadingAnchor, constant: 12),
            tableSeatPlace.centerYAnchor.constraint(equalTo: waitressCallBack.centerYAnchor),
            tableSeatPlace.widthAnchor.constraint(equalToConstant: 24),
            tableSeatPlace.heightAnchor.constraint(equalToConstant: 24),
            
           
            chairComfortMark.leadingAnchor.constraint(equalTo: tableSeatPlace.trailingAnchor, constant: 8),
            chairComfortMark.trailingAnchor.constraint(equalTo: waitressCallBack.trailingAnchor, constant: -12),
            chairComfortMark.topAnchor.constraint(equalTo: waitressCallBack.topAnchor, constant: 12),
            chairComfortMark.bottomAnchor.constraint(equalTo: waitressCallBack.bottomAnchor, constant: -12)
        ])
        
       
        menuPageLayout.layoutIfNeeded()
        musicVolumeAmbiance.constant = waiterSignLink + 10 // 滑入到安全区域下方 10 点
        
        UIView.animate(withDuration: trayCarryLevel, delay: 0, options: .curveEaseOut, animations: {
            menuPageLayout.layoutIfNeeded()
        }, completion: { _ in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + napkinFoldStyle) {
                musicVolumeAmbiance.constant = -waitressCallBack.frame.height - 10 // 再次移出屏幕
                
                UIView.animate(withDuration: trayCarryLevel, delay: 0, options: .curveEaseIn, animations: {
                    menuPageLayout.layoutIfNeeded()
                }, completion: { _ in
                    waitressCallBack.removeFromSuperview()
                })
            }
        })
    }
}

