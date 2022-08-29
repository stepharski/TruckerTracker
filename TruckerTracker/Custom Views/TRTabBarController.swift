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
        let homeNavController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.homeNavigationController) as! UINavigationController
        let newItemNavController = self.storyboard?.instantiateViewController( withIdentifier: StoryboardIdentifiers.newItemNavigationController) as! UINavigationController
        let profileNavController = self.storyboard?.instantiateViewController( withIdentifier: StoryboardIdentifiers.profileNavigationController) as! UINavigationController
        
        homeNavController.tabBarItem = UITabBarItem(title: nil,
                                                    image: TRTabBarItem.home.image,
                                                    selectedImage: TRTabBarItem.home.selectedImage)
        newItemNavController.tabBarItem = UITabBarItem(title: nil,
                                                       image: TRTabBarItem.newItem.image,
                                                       selectedImage: TRTabBarItem.newItem.selectedImage)
        profileNavController.tabBarItem = UITabBarItem(title: nil,
                                                       image: TRTabBarItem.profile.image,
                                                       selectedImage: TRTabBarItem.profile.selectedImage)
        
        
        viewControllers = [homeNavController, newItemNavController, profileNavController]
    }
        
    func handleTabBarItemTap() {
        guard let tabBar = self.tabBar as? TRTabBar else { return }
        
        tabBar.didTapNewItemButton = { [unowned self] in
            self.presentNewItemNavController()
        }
    }
    
    func presentNewItemNavController() {
        let newItemNavController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.newItemNavigationController) as! UINavigationController
        newItemNavController.modalPresentationCapturesStatusBarAppearance = true
        self.present(newItemNavController, animated: true)
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
