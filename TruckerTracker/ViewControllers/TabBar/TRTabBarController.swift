//
//  TRTabBarController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/26/22.
//

import UIKit

class TRTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        createTabBarItems()
        handleTabBarItemTap()
    }
    
    
    func configureTabBar() {
        delegate = self
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white.withAlphaComponent(0.01)

        self.tabBar.tintColor = .label
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
    
    func createTabBarItems() {
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier:
                                            StoryboardIdentifiers.homeVC) as! HomeVC
        let categoryItemVC = storyboard?.instantiateViewController(withIdentifier:
                                            StoryboardIdentifiers.categoryItemVC) as! CategoryItemVC
        let profileVC = storyboard?.instantiateViewController(withIdentifier:
                                            StoryboardIdentifiers.profileVC) as! ProfileVC
        
        let homeNavController = UINavigationController(rootViewController: homeVC)
        let categoryitemNavController = UINavigationController(rootViewController: categoryItemVC)
        let profileNavController = UINavigationController(rootViewController: profileVC)

        homeVC.tabBarItem = UITabBarItem(title: nil,
                                         image: TRTabBarItem.home.image,
                                         selectedImage: TRTabBarItem.home.selectedImage)
        categoryitemNavController.tabBarItem = UITabBarItem(title: nil,
                                                       image: TRTabBarItem.newItem.image,
                                                       selectedImage: TRTabBarItem.newItem.selectedImage)
        profileNavController.tabBarItem = UITabBarItem(title: nil,
                                                       image: TRTabBarItem.profile.image,
                                                       selectedImage: TRTabBarItem.profile.selectedImage)

        viewControllers = [homeNavController, categoryitemNavController, profileNavController]
    }
        
    func handleTabBarItemTap() {
        guard let tabBar = self.tabBar as? TRTabBar else { return }
        
        tabBar.didTapNewItemButton = { [unowned self] in
            self.presentNewItemNavController()
        }
    }
    
    func presentNewItemNavController() {
        let categoryItemVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardIdentifiers.categoryItemVC) as! CategoryItemVC
        let categoryItemNavController = UINavigationController(rootViewController: categoryItemVC)
        categoryItemNavController.modalPresentationCapturesStatusBarAppearance = true

        self.present(categoryItemNavController, animated: true)
    }
}


// MARK: - UITabBarControllerDelegate
extension TRTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        // new item button
        if selectedIndex == 1 {
            return false
        }
        
        return true
    }
}
