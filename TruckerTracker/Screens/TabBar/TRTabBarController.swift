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
        
        let dashboardVC = storyboard?.instantiateViewController(withIdentifier:
                        StoryboardIdentifiers.dashboardViewController) as! DashboardViewController
        let itemEntryVC = storyboard?.instantiateViewController(withIdentifier:
                        StoryboardIdentifiers.itemEntryViewController) as! ItemEntryViewController
        let toolsVC = storyboard?.instantiateViewController(withIdentifier:
                        StoryboardIdentifiers.toolsViewController) as! ToolsViewController
        
        let dashboardNavController = UINavigationController(rootViewController: dashboardVC)
        let itemEntryNavController = UINavigationController(rootViewController: itemEntryVC)
        let toolsNavController = UINavigationController(rootViewController: toolsVC)

        dashboardVC.tabBarItem = UITabBarItem(title: nil,
                                         image: TRTabBarItem.dashboard.image,
                                         selectedImage: TRTabBarItem.dashboard.image)
        itemEntryNavController.tabBarItem = UITabBarItem(title: nil,
                                           image: TRTabBarItem.newItem.image,
                                           selectedImage: TRTabBarItem.newItem.image)
        toolsNavController.tabBarItem = UITabBarItem(title: nil,
                                           image: TRTabBarItem.tools.image,
                                           selectedImage: TRTabBarItem.tools.image)

        viewControllers = [dashboardNavController, itemEntryNavController, toolsNavController]
    }
        
    func handleTabBarItemTap() {
        guard let tabBar = self.tabBar as? TRTabBar else { return }
        
        tabBar.didTapNewItemButton = { [unowned self] in
            self.presentNewItemNavController()
        }
    }
    
    func presentNewItemNavController() {
        let itemEntryVC = storyboard?.instantiateViewController(withIdentifier:
                        StoryboardIdentifiers.itemEntryViewController) as! ItemEntryViewController
        let itemNavController = UINavigationController(rootViewController: itemEntryVC)

        self.present(itemNavController, animated: true)
    }
}


// MARK: - UITabBarControllerDelegate
extension TRTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        // new item button
        if selectedIndex == 1 { return false }
        
        return true
    }
}
