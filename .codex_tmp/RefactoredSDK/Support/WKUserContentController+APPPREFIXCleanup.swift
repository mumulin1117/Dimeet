import WebKit

extension WKUserContentController {
    func APPPREFIX_removeAllBridgeHandlers() {
        removeScriptMessageHandler(forName: HNONWCcasualChic.WebBridge.rechargePay)
        removeScriptMessageHandler(forName: HNONWCcasualChic.WebBridge.close)
        removeScriptMessageHandler(forName: HNONWCcasualChic.WebBridge.pageLoaded)
        removeScriptMessageHandler(forName: HNONWCcasualChic.WebBridge.openBrowser)
    }
}
