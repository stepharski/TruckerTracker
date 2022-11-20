//
//  ProfileVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/26/22.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let menuItems = ProfileMenuType.allCases
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureCollectionView()
    }
    
    
    func configureNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white.withAlphaComponent(0.01)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(ProfileHeaderView.nib,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: ProfileHeaderView.identifier)
        collectionView.register(ProfileMenuCell.nib, forCellWithReuseIdentifier: ProfileMenuCell.identifier)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileMenuCell.identifier,
                                                      for: indexPath) as! ProfileMenuCell
        let menuItem = menuItems[indexPath.row]
        cell.configure(with: menuItem.image,
                       title: menuItem.title,
                       subtitle: menuItem.subtitle)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                 withReuseIdentifier: ProfileHeaderView.identifier,
                                                                 for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let menuItem = menuItems[indexPath.row].title
        print("\(menuItem) menu tapped")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemPadding: CGFloat = 20
        return CGSize(width: (collectionView.bounds.width - (3 * itemPadding)) / 2, height: 170)
    }
}
