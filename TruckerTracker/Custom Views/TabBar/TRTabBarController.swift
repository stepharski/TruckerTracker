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
    }
    
    func createTabBarItems() {
        
        let trackerVC = storyboard?.instantiateViewController(withIdentifier:
                                                        StoryboardIdentifiers.trackerVC) as! TrackerVC
        let categoryItemVC = storyboard?.instantiateViewController(withIdentifier:
                                                        StoryboardIdentifiers.categoryItemVC) as! CategoryItemVC
        let profileVC = storyboard?.instantiateViewController(withIdentifier:
                                                        StoryboardIdentifiers.profileVC) as! ProfileVC
        
        let trackerNavController = UINavigationController(rootViewController: trackerVC)
        let categoryitemNavController = UINavigationController(rootViewController: categoryItemVC)
        let profileNavController = UINavigationController(rootViewController: profileVC)

        trackerNavController.tabBarItem = UITabBarItem(title: nil,
                                                    image: TRTabBarItem.tracker.image,
                                                    selectedImage: TRTabBarItem.tracker.selectedImage)
        categoryitemNavController.tabBarItem = UITabBarItem(title: nil,
                                                       image: TRTabBarItem.newItem.image,
                                                       selectedImage: TRTabBarItem.newItem.selectedImage)
        profileNavController.tabBarItem = UITabBarItem(title: nil,
                                                       image: TRTabBarItem.profile.image,
                                                       selectedImage: TRTabBarItem.profile.selectedImage)

        viewControllers = [trackerNavController, categoryitemNavController, profileNavController]
    }
    
    func testCreateTabbarItems() {
        
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
