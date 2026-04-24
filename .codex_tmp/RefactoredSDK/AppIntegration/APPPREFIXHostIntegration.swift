import Foundation
import UIKit

public final class APPPREFIXHostTheme {
    public var launchBackgroundImageName: String = "characterdesign"
    public var mainBackgroundImageName: String = "propcollection"
    public var loginButtonBackgroundImageName: String = "vjiajdkld"
    public var loginAccessoryImageName: String = ""
    public var loginButtonWidth: CGFloat = 343
    public var loginButtonHeight: CGFloat = 49
    public var loginButtonTextColor: UIColor = .black
    public var loginAccessoryImageWidth: CGFloat = 0
    public var loginAccessoryImageHeight: CGFloat = 0

    public init() {}
}

public final class APPPREFIXHostEndpoints {
    public var releaseBaseURL: String = "https://opi.e6b15du6.link"
    public var releaseAppID: String = "45448564"
    public var releaseAESKey: String = "ub31ewehkye34qgt"
    public var releaseAESIV: String = "ndt2jda0flylj2bx"
    public var launchDetailPath: String = "/opi/v1/....o"
    public var loginPath: String = "/opi/v1/....l"
    public var reportTimePath: String = "/opi/v1/....t"
    public var verifyReceiptPath: String = "/opi/v1/....p"

    public init() {}
}

public final class APPPREFIXHostMessages {
    public var loadingMessage: String = "Loading..."
    public var quickLoginTitle: String = "Quickly Log"
    public var invalidLoginInfoMessage: String = "Login info invalid!"
    public var purchaseDisabledMessage: String = "In-App Purchases are disabled on this device."
    public var missingProductMessage: String = "No valid product found."
    public var paymentCancelledMessage: String = "Payment cancelled"
    public var transactionFailedMessage: String = "Transaction failed."
    public var paymentSuccessMessage: String = "Pay Successful"
    public var paymentFailedMessage: String = "Pay failed"

    public init() {}
}

public final class APPPREFIXHostFeatures {
    public var launchRequestTimeInterval: TimeInterval = 0
    public var appARootHandler: ((UIWindow?) -> Void)?

    public init() {}
}

public final class APPPREFIXHostResources {
    public var encryptedResourceHexKey: String = "5E7C8B9A0D3F2146C5B8A9D0E7F13C249B6E0D1F4A5C7B2E8D3F1C0A6B9E4D5F"
    public var encryptedResourceExtension: String = "enc"

    public init() {}
}
