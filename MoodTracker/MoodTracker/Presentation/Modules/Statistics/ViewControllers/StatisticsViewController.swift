//
//  StatisticsViewController.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 01.10.2024.
//

import Common
import Design
import UIKit
import SwiftUI

protocol StatisticsView: AnyObject {
    func setTitle(_ title: String)
    func setStatisticView(
        factText: String,
        moodsScores: [MoodNoteViewItem],
        segments: [String],
        date: String,
        moodDistribution: [MoodDistributionViewItem],
        onSelectedSegmentChanged: @escaping (String) -> Void
    )
}

final class StatisticsViewController: UIViewController {
    // MARK: - Internal properties
    
    private lazy var navBar: NavigationBar = {
        let navBar = NavigationBar()
        navBar.delegate = self
        navBar.isBackButtonHidden = true
        return navBar
    }()
    
    private var statisticsDataViewModel = StatisticsDataViewModel()
    private lazy var statisticsDataViewController = UIHostingController(
        rootView: StatisticsDataView(statisticsDataViewModel: statisticsDataViewModel)
    )
    private lazy var statisticsDataView = statisticsDataViewController.view!
    
    var presenter: StatisticsPresenter?
    
    // MARK: - Private properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupConstraints()
        setupViews()
        
        presenter?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.onViewVillAppear()
    }
}

// MARK: - Private methods

private extension StatisticsViewController {
    func addSubviews() {
        addChild(statisticsDataViewController)
        view.addSubviews(navBar, statisticsDataView)
        
        view.bringSubviewToFront(navBar)
    }
    
    func setupConstraints() {
        extendedLayoutIncludesOpaqueBars = true
        view.layoutMargins = .zero
        
        NSLayoutConstraint.useAndActivateConstraints([
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            statisticsDataView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 8),
            statisticsDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statisticsDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        statisticsDataViewController.didMove(toParent: self)
    }
    
    func setupViews() {
        view.backgroundColor = AppResources.colors.background
    }
}

// MARK: - StatisticsView

extension StatisticsViewController: StatisticsView {
    func setStatisticView(
        factText: String,
        moodsScores: [MoodNoteViewItem],
        segments: [String],
        date: String,
        moodDistribution: [MoodDistributionViewItem],
        onSelectedSegmentChanged: @escaping (String) -> Void
    ) {
        statisticsDataViewModel.setupData(
            factText: factText,
            moodsScores: moodsScores,
            segments: segments,
            date: date,
            moodDistribution: moodDistribution,
            onSelectedSegmentChanged: onSelectedSegmentChanged
        )
    }
    
    func setTitle(_ title: String) {
        navBar.title = title
    }
}

// MARK: - NavigationBarDelegate

extension StatisticsViewController: NavigationBarDelegate {
    func didReceiveBackAction(_ navigationBar: NavigationBar) {
        // В других экранах должен быть leave, но мы находимся на главном экране
        // presenter?.leave()
    }
}

// MARK: - Constants

private extension StatisticsViewController {
}
