//
//  OnBoardingViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/26/24.
//

import UIKit

// MARK: - OnBoardingViewController
final class OnBoardingViewController: UIViewController {

    // MARK: @IBOutlet

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet private var nextButtonView: UIView!
    @IBOutlet private var nextButtonTitleLabel: UILabel!

    @IBOutlet private var nextButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var nextButtonBottomConstraint: NSLayoutConstraint!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }

    // MARK: UI Setup
    private func setupUI() {
        view.applyGradient(colors: AppColors.headerColors, locations: [0, 1])
        nextButtonView.roundEdges(by: nextButtonView.frame.height / 2)
        nextButtonBottomConstraint.constant = -(nextButtonView.frame.height / 4)
        nextButtonTrailingConstraint.constant = -(nextButtonView.frame.width / 4)
    }

    // MARK: Collection View
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: UserDefaults
    private func setupCompletion() {
        // After last screen
        UDManager.shared.isFirstLaunch = false
        UDManager.shared.userSinceDate = .now.local.startOfDay
    }
}

// MARK: - UICollectionViewDelegate
extension OnBoardingViewController: UICollectionViewDelegate { }

// MARK: - UICollectionView DataSource
extension OnBoardingViewController: UICollectionViewDataSource {
    // Number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    // Cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // FIXME: Add cell
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    // Item size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
