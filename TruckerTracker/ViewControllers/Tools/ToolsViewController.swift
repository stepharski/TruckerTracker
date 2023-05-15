//
//  ToolsViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/14/23.
//

import UIKit

class ToolsViewController: UIViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var avatarBackgroundView: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    let tools = ToolsType.allCases
    let itemPadding: CGFloat = 20
    
    let imagePicker = ImagePickerManager()
    
    var avatarImage: UIImage? {
        didSet { avatarImageView.image = avatarImage }
    }
    
    
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
        navigationItem.title = "Tools"
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
        collectionView.register(ToolCell.nib, forCellWithReuseIdentifier: ToolCell.identifier)
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
    func showToolMenuVC(for tool: ToolsType) {
        let toolMenuVC = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.toolMenuViewController) as! ToolMenuViewController
        toolMenuVC.selectedTool = tool
        navigationController?.pushViewController(toolMenuVC, animated: true)
    }
}

// MARK: - UICollectionView DataSource
extension ToolsViewController: UICollectionViewDataSource {
    // Number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tools.count
    }
    
    // Cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolCell.identifier,
                                                              for: indexPath) as! ToolCell
        let tool = tools[indexPath.row]
        cell.configure(with: tool.image, title: tool.title, subtitle: tool.subtitle)
        
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension ToolsViewController: UICollectionViewDelegate {
    // Selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showToolMenuVC(for: tools[indexPath.item])
    }
}

// MARK: - UICollectionView Delegate FlowLayout
extension ToolsViewController: UICollectionViewDelegateFlowLayout {
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
