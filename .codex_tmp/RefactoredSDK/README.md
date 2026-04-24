# RefactoredSDK

## 目标

- 保留原有功能结果
- 保留原有公开 API 行为
- 保留原有用户可见文案含义
- 将主题、资源、入口回调、文案、功能开关沉到 App 接入层
- 将网络、加密、支付、存储、Web bridge 拆成独立能力

## 文件映射

| 原文件 | 新文件 |
| --- | --- |
| `TgextileLuster.swift` | `Public/TgextileLuster.swift` + `AppIntegration/APPPREFIXHostIntegration.swift` |
| `HNONWCEwhimsicalMotif.swift` | `Public/HNONWCEwhimsicalMotif.swift` |
| `DSummerRadiance.swift` | `Public/DSummerRadiance.swift` + `Launch/APPPREFIXLaunchEnvironmentCollector.swift` + `Launch/APPPREFIX_AppLaunchController.swift` |
| `EoutfitCuration.swift` | `Public/HNONYtailoringPrecision.swift` + `Auth/EoutfitCuration.swift` |
| `HNONWCdazzlingPresence.swift` | `Public/HNONWCdazzlingPresenceParamaKey.swift` + `Web/HNONWCdazzlingPresence.swift` |
| `HNONWCEsilkDrape.swift` | `Networking/HNONWCEsilkDrape.swift` + `Networking/APPPREFIXRequestHeaderFactory.swift` + `Networking/APPPREFIXResponseDecoder.swift` |
| `EcelebrationGarment.swift` | `Security/EcelebrationGarment.swift` |
| `HNONWCEestheticCoordination.swift` | `Persistence/HNONWCEestheticCoordination.swift` + `Persistence/APPPREFIXKeychainStore.swift` + `Persistence/Data+APPPREFIXHex.swift` |
| `HNONWYCELRPutAccessory.swift` | `Payments/HNONWYCELRPutAccessory.swift` |
| `HNONWYCELRStyleSparkNotifier.swift` | `UI/HNONWYCELRStyleSparkNotifier.swift` |
| `HNONWYCELRcolorfusioning.swift` | `Resources/HNONWYCELRcolorfusioning.swift` |
| `HNONWCcasualChic.swift` | `Support/HNONWCcasualChic.swift` |
| 隐式依赖 | `Support/APPPREFIXMainWindowProvider.swift` + `Support/APPPREFIXBackgroundSceneInstaller.swift` + `Support/APPPREFIXQuickLoginButtonFactory.swift` + `Support/APPPREFIXSessionAssembler.swift` + `Support/Bundle+APPPREFIXAppVersion.swift` + `Support/WKUserContentController+APPPREFIXCleanup.swift` |

## 保留的公开 API

- `TgextileLuster.shared`
- `TgextileLuster` 上原有配置字段和只读计算字段
- `TgextileLuster.APPPREFIX_setting_App_A_Root()`
- `HNONWCEwhimsicalMotif.APPPREFIX_config`
- `HNONWCEwhimsicalMotif.APPPREFIX_initializeSDK(with:)`
- `HNONWCEwhimsicalMotif.APPPREFIX_getLaunchViewController()`
- `HNONWCEwhimsicalMotif.APPPREFIX_didRegisterForRemoteNotifications(deviceToken:)`
- `DSummerRadiance`
- `HNONYtailoringPrecision`
- `HNONWCdazzlingPresenceParamaKey`

## App 接入层能力

`AppIntegration/APPPREFIXHostIntegration.swift` 中新增了这几类宿主配置：

- `APPPREFIXHostTheme`
- `APPPREFIXHostEndpoints`
- `APPPREFIXHostMessages`
- `APPPREFIXHostFeatures`
- `APPPREFIXHostResources`

这些配置已经由 `TgextileLuster` 的旧字段桥接，不需要强制改原接入代码。

## 接入示例

```swift
let sdk = HNONWCEwhimsicalMotif.shared
let config = sdk.APPPREFIX_config

config.APPPREFIX_debugMode = false
config.APPPREFIX_realseBaseURL = "https://example.com"
config.APPPREFIX_realseAPPID = "12345678"
config.APPPREFIX_realseAesKey = "1234567890abcdef"
config.APPPREFIX_realseAesIV = "abcdef1234567890"

config.APPPREFIX_LaunchBackgroundImage = "launch_bg"
config.APPPREFIX_mainBackgroundImage = "login_bg"
config.APPPREFIX_loginButtonBackImage = "login_button"

config.APPPREFIX_setting_App_A_Root_Handler = { window in
    window?.rootViewController = HostMainViewController()
}

sdk.APPPREFIX_initializeSDK(with: window)
window.rootViewController = sdk.APPPREFIX_getLaunchViewController()
```

## 风险清单

1. `StoreKit 1` 仍然沿用原链路，所以在新 SDK 下可以保留原行为，但在高版本 SDK 上会看到弃用告警。
2. 原实现对 `AppDelegate` 的字符串依赖已移除，改为从 `TgextileLuster.APPPREFIX_messages` 取文案。如果宿主之前依赖自定义解密文案，需要在接入层覆盖这些字段。
3. `HNONWCEwhimsicalMotif.shared` 在这次结果里提升为可访问单例，用来修复原 SDK 作为独立模块时无法从宿主直接拿到入口的问题。
4. 加密资源加载器改成从 `TgextileLuster` 取密钥和后缀，默认值保持原结果。如果宿主使用别的加密参数，需要在接入层覆盖。
5. 这套代码是独立源码输出，没有替换原工程内的引用关系；正式接入前还需要把新文件加入 target。

## 校验

- 已执行 `swiftc -typecheck`
- 当前结果通过类型检查，剩余为系统 API 弃用告警
