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
    func setNote(_ note: String)
    func setChart()
}

final class StatisticsViewController: UIViewController {
    // MARK: - Internal properties
    
    private lazy var navBar: NavigationBar = {
        let navBar = NavigationBar()
        navBar.delegate = self
        navBar.isBackButtonHidden = true
        return navBar
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Constants.L10n.monthPage, Constants.L10n.weekPage])
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = .zero
        return segmentedControl
    }()
    
    private var chartViewModel = ChartViewModel()
    private lazy var chartViewController = UIHostingController(rootView: ChartView(chartViewModel: chartViewModel))
    private lazy var chartView = chartViewController.view!
    
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
}

// MARK: - Private methods

private extension StatisticsViewController {
    func addSubviews() {
        addChild(chartViewController)
        view.addSubviews(navBar, segmentedControl, chartView)
        
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
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.topAnchor.constraint(equalTo: navBar.bottomAnchor)
        ])
        
        NSLayoutConstraint.useAndActivateConstraints([
            chartView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 24),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        chartViewController.didMove(toParent: self)
        // TODO: Refactor to real data
        chartViewModel.moodsScores = [1,2,3,4,4,4,5,4,2,3,5,1,5,2,3,5,4,1,2,4,1,5,1,5,4,2,3,5,1,5,2,3,5,]
            .enumerated()
            .map {
                MoodNote(position: $0.offset, score: $0.element)
            }
    }
    
    func setupViews() {
        view.backgroundColor = AppResources.colors.background
    }
    
    @objc
    func segmentChanged(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            // TODO: Refactor to real data
            chartViewModel.moodsScores = [1,2,3,4,4,4,5,4,2,3,5,1,5,2,3,5,4,1,2,4,1,5,1,5,4,2,3,5,1,5,2,3,5,]
                .enumerated()
                .map {
                    MoodNote(position: $0.offset, score: $0.element)
                }
            
        case 1:
            // TODO: Refactor to real data
            chartViewModel.moodsScores = [4,1,2,4,1,5,1]
                .enumerated()
                .map {
                    MoodNote(position: $0.offset, score: $0.element)
                }
            
        default:
            break
        }
    }
}

// MARK: - StatisticsView

extension StatisticsViewController: StatisticsView {
    func setTitle(_ title: String) {
        navBar.title = title
    }
    
    func setChart() {
    }
    
    func setNote(_ note: String) {
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
    enum Constants {
        enum L10n {
            static let monthPage: String = "Месяц"
            static let weekPage: String = "Неделя"
        }
    }
}
