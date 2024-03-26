//
//  SceneDelegate.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/25/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, 
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene,
                let window = windowScene.windows.first else { return }
        
        // Assign App Theme
        window.overrideUserInterfaceStyle = UDManager.shared.appTheme.style
    }
}
