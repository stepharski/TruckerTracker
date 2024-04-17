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
    @IBOutlet private var backButtonView: UIImageView!
    @IBOutlet private var nextButtonView: UIView!
    @IBOutlet private var nextButtonTitleLabel: UILabel!
    @IBOutlet private var nextButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var nextButtonBottomConstraint: NSLayoutConstraint!

    // MARK: Variables
    private var viewModel = OnBoardingViewModel()
    private var slide = OnBoardingSlide.howdy {
        didSet { updateUI() }
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindGestures()
        configureCollectionView()
        backButtonView.isHidden = true
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

    private func updateUI() {
        //TODO: Update page indicator
        nextButtonTitleLabel.text = slide.buttonTitle
        backButtonView.isHidden = slide.rawValue == 0
        collectionView.reloadData()
    }

    // MARK: Collection View
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            HowdyOnBoardingCell.nib,
            forCellWithReuseIdentifier: HowdyOnBoardingCell.identifier)
        collectionView.register(
            DrivingModeOnBoardingCell.nib,
            forCellWithReuseIdentifier: DrivingModeOnBoardingCell.identifier)
        collectionView.register(
            EarningsOnBoardingCell.nib,
            forCellWithReuseIdentifier: EarningsOnBoardingCell.identifier)
    }

    // MARK: Slides Navigation
    private func bindGestures() {
        let tapGestureNext = UITapGestureRecognizer(target: self, action: #selector(moveToNextScreen))
        nextButtonView.addGestureRecognizer(tapGestureNext)
        let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(moveToPreviousScreen))
        backButtonView.addGestureRecognizer(tapGestureBack)
    }

    @objc private func moveToNextScreen() {
        guard OnBoardingSlide.allCases.count - 1 > slide.rawValue else {
            // TODO: Save user
            print("Save user")
            return
        }
        slide = OnBoardingSlide.allCases[slide.rawValue + 1]
    }

    @objc private func moveToPreviousScreen() {
        guard slide.rawValue > 0 else { return }
        slide = OnBoardingSlide.allCases[slide.rawValue - 1]
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
        switch slide {
        case .howdy:
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: HowdyOnBoardingCell.identifier,
                for: indexPath) as! HowdyOnBoardingCell
        case .drivingMode:
           let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DrivingModeOnBoardingCell.identifier,
                for: indexPath) as! DrivingModeOnBoardingCell

            cell.didSelectTeamMode = { [weak self] isTeam in
                guard let self else { return }
                // TODO: Update VM
                print("isTeam = \(isTeam)")
            }
            return cell
        case .earnings:
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: EarningsOnBoardingCell.identifier,
                for: indexPath) as! EarningsOnBoardingCell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    // Item size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
