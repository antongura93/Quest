import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pointScreen = OnboardingScreen()
        let hostContrRoot = UIHostingController(rootView: pointScreen)
        
        addChild(hostContrRoot)
        view.addSubview(hostContrRoot.view)
        hostContrRoot.didMove(toParent: self)
        
        hostContrRoot.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostContrRoot.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostContrRoot.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostContrRoot.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostContrRoot.view.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func rootViewCntrl(_ viewController: UIViewController) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = viewController
        }
    }
    
    func stringPredicat(mainStingValue: String, deviceID: String, advertaiseID: String, appsflId: String) -> (String) {
        var finishStr = ""
        
        finishStr = "\(mainStingValue)?phft=\(deviceID)&pdgs=\(advertaiseID)&pbst=\(appsflId)"
        
        return finishStr
    }
    
    
    func StartHandler() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let onboardingView = FirstInfoScreen()
            let hostingRootController = UIHostingController(rootView: onboardingView)
            self.rootViewCntrl(hostingRootController)
        }
    }
    
    
    func FinishHandler(string: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for child in self.children {
                if child is AppViewController {
                    return
                }
            }
            guard !string.isEmpty else { return }
            let theSecondController = AppViewController(urlStr: string)
            self.addChild(theSecondController)
            theSecondController.view.frame = self.view.bounds
            theSecondController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(theSecondController.view)
            theSecondController.didMove(toParent: self)
        }
    }
}
