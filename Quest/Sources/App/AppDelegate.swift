import SwiftUI
import FirebaseCore
import FirebaseAuth
import SdkPushExpress
import AppsFlyerLib
import AppTrackingTransparency
import FirebaseAnalytics
import FirebaseInstallations
import FirebaseRemoteConfigInternal
import AdSupport


@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, DeepLinkDelegate {
    var timeValue = 0
    var analyticId: String = ""
    var ident: String = ""
    private var privateExternalId = ""
    private let privatePushAppId = "40229-1202"
    private var remoteConfig: RemoteConfig?
    var window: UIWindow?
    weak var initViewController: ViewController?
    static var UnitOrientation = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        remoteConfig = RemoteConfig.remoteConfig()
        setupConfig()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = ViewController()
        initViewController = viewController
        window?.rootViewController = initViewController
        window?.makeKeyAndVisible()
        
        AppsFlyerLib.shared().appsFlyerDevKey = "RV9k8x9P2NNHtLUciFzoP6"
        AppsFlyerLib.shared().appleAppID = "6746485328"
        AppsFlyerLib.shared().deepLinkDelegate = self
        AppsFlyerLib.shared().delegate = self
        
        Task { @MainActor in
            analyticId = await fetchAnalyticsId()
            privateExternalId = analyticId
        }
        
        viewDidLoad(viewController: viewController)
        
        AppsFlyerLib.shared().start()
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        
        privateExternalId = analyticId
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if error != nil {
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            do {
                try PushExpressManager.shared.initialize(appId: self.privatePushAppId)
                try PushExpressManager.shared.activate(extId: self.privateExternalId)
            } catch {
                print(" Error initializing or activating PushExpressManager: \(error)")
            }
            
            if !PushExpressManager.shared.notificationsPermissionGranted {
                print(" Notifications permission not granted. Please enable notifications in Settings.")
            }
        }
        
        return true
    }
    
    func fetchAnalyticsId() async -> String {
        do {
            if let appInstanceID = Analytics.appInstanceID() {
                return appInstanceID
            } else {
                return ""
            }
        }
    }
    
    func setupConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.UnitOrientation
    }
    
    func viewDidLoad(viewController: ViewController) {
        remoteConfig?.fetch { [weak self] status, error in
            guard let self = self else { return }
            
            if status == .success {
                let appsID = AppsFlyerLib.shared().getAppsFlyerUID()
                
                self.remoteConfig?.activate { _, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            viewController.StartHandler()
                            return
                        }
                        
                        if let remString = self.remoteConfig?.configValue(forKey: "quest").stringValue {
                            if !remString.isEmpty {
                                if let finalURL = UserDefaults.standard.string(forKey: "finalURL") {
                                    viewController.FinishHandler(string: finalURL)
                                    print(" SECOND OPEN: \(finalURL)")
                                    return
                                }
                                
                                if self.ident.isEmpty {
                                    self.timeValue = 5
                                    self.ident = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                                }
                                
                                if self.ident.isEmpty {
                                    viewController.StartHandler()
                                    return
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(self.timeValue)) {
                                    let stringURL = viewController.stringPredicat(mainStingValue: remString, deviceID: self.analyticId, advertaiseID: self.ident, appsflId: appsID)
                                    
                                    print(" Result: \(stringURL)")
                                    
                                    guard let url = URL(string: stringURL) else {
                                        viewController.StartHandler()
                                        return
                                    }
                                    
                                    if UIApplication.shared.canOpenURL(url) {
                                        viewController.FinishHandler(string: stringURL)
                                    } else {
                                        viewController.StartHandler()
                                    }
                                }
                                
                            } else {
                                viewController.StartHandler()
                            }
                        } else {
                            viewController.StartHandler()
                        }
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        ATTrackingManager.requestTrackingAuthorization { (status) in
            self.timeValue = 10
            switch status {
            case .authorized:
                self.ident = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                self.timeValue = 1
            case .denied:
                self.ident = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            case .notDetermined:
                print(" Not Determined")
            case .restricted:
                print(" Restricted")
            @unknown default:
                print(" Unknown")
            }
        }
        AppsFlyerLib.shared().start()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokPart = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let tok = tokPart.joined()
        PushExpressManager.shared.transportToken = tok
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(" Failed to register remote notifications: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print(" Notification response: \(userInfo)")
        NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotification"), object: nil, userInfo: userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        print(" Received notification while app is in foreground mode: \(userInfo)")
        completionHandler([.banner, .list, .sound])
    }

}


extension AppDelegate: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        print(" onConversionDataSuccess \(data)")
    }
    
    func onConversionDataFail(_ error: Error) {
        print (" onConversionDataFail \(error)")
    }
}
