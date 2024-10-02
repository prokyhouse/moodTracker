//
//  StatisticsViewController.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 01.10.2024.
//

import Common
import Design
import UIKit

protocol StatisticsView: AnyObject {

}

final class StatisticsViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: StatisticsPresenter?

    // MARK: - Private properties


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
}

// MARK: - Private methods

private extension StatisticsViewController {
 
}

// MARK: - StatisticsView

extension StatisticsViewController: StatisticsView {
  
}

// MARK: - Constants

private extension StatisticsViewController {
    enum Constants {

    }
}
