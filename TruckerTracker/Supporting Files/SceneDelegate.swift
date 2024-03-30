//
//  SceneDelegate.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/25/22.
//

import UIKit

// MARK: - SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: Scene
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
                   options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        guard let window = windowScene.windows.first else { return }

        // Assign App Theme
        window.overrideUserInterfaceStyle = UDManager.shared.appTheme.style

        // FIXME: Testing 
        launchOnBoardingStoryboard(in: window)
        // Check if new user
//        if UDManager.shared.isFirstLaunch { launchOnBoardingStoryboard(in: window) }
//        else { launchMainStoryboard(in: window) }
    }

    // MARK: Storyboards Launch
    private func launchOnBoardingStoryboard(in window: UIWindow) {
        let storyboard = UIStoryboard(name: StoryboardIdentifiers.onBoardingStoryboard, bundle: nil)
        let onBoardingVC = storyboard.instantiateViewController(withIdentifier:
                                    StoryboardIdentifiers.onBoardingController)
        window.rootViewController = onBoardingVC
        window.makeKeyAndVisible()
    }

    private func launchMainStoryboard(in window: UIWindow) {
        let storyboard = UIStoryboard(name: StoryboardIdentifiers.mainStoryboard, bundle: nil)
        let onBoardingVC = storyboard.instantiateViewController(withIdentifier:
                                    StoryboardIdentifiers.tabBarController)
        window.rootViewController = onBoardingVC
        window.makeKeyAndVisible()
    }
}
