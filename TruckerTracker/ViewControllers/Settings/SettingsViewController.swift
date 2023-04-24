//
//  SettingsViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/9/23.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var avatarBackgroundView: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    let settingsItems = SettingsType.allCases
    let itemPadding: CGFloat = 20
    
    var avatarImage: UIImage? {
        didSet { avatarImageView.image = avatarImage }
    }
    
    let imagePicker = ImagePickerManager()
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        updateHeaderHeight()
        
        configureAvatar()
        bindGestureToAvatar()
        configurePlusButton()
        
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureHeader()
    }
    
    // @IBAction
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        changeProfilePicture()
    }
    

    // Configuration
    func configureNavBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:
                                                            AppColors.textColor]
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white.withAlphaComponent(0.01)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func configureHeader() {
        headerView.dropShadow(opacity: 0.3)
        headerView.applyGradient(colors: AppColors.headerColors, locations: [0, 1])
    }
    
    func updateHeaderHeight() {
        headerViewHeightConstraint.constant = DeviceTypes.isiPhoneSE ? 225 : 265
    }
    
    func configureAvatar() {
        avatarImageView.roundEdges(by: 50)
        avatarBackgroundView.roundEdges(by: 50)
        avatarBackgroundView.dropShadow(color: .white, size: .zero)
    }
    
    func bindGestureToAvatar() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePicture))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    func configurePlusButton() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.image = SFSymbols.plus?
                .withConfiguration(UIImage.SymbolConfiguration(scale: .small))
        config.baseBackgroundColor = #colorLiteral(red: 0.07450980392, green: 0.1450980392, blue: 0.1254901961, alpha: 1)
        config.baseForegroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        config.background.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        config.background.strokeWidth = 1.0
        
        plusButton.configuration = config
        plusButton.tintAdjustmentMode = .normal
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SettingsCell.nib, forCellWithReuseIdentifier: SettingsCell.identifier)
    }
    
    // Profile picture
    @objc func changeProfilePicture() {
        imagePicker.showImagePicker(in: self) { [weak self] image in
            guard image != nil else { return }
            self?.avatarImage = image
            //TODO: Cache and Save Image
        }
    }
    
    // Navigation
    func showSetting(_ setting: SettingsType) {
        let settingDetailVC = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.settingDetailViewController) as! SettingDetailViewController
        settingDetailVC.setting = setting
        navigationController?.pushViewController(settingDetailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension SettingsViewController: UICollectionViewDataSource {
    // Number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    // Cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsCell.identifier,
                                                              for: indexPath) as! SettingsCell
        let settingsItem = settingsItems[indexPath.row]
        cell.configure(with: settingsItem.image, title: settingsItem.title,
                                                   subtitle: settingsItem.subtitle)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SettingsViewController: UICollectionViewDelegate {
    // Selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showSetting(settingsItems[indexPath.item])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    // Item size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - (3 * itemPadding)) / 2, height: 170)
    }
    
    // Inter item spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
    // Line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
    // Section insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: itemPadding + 5, left: itemPadding,
                            bottom: itemPadding, right: itemPadding)
    }
}
