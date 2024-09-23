//
//  TabBarController.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Design
import UIKit

protocol NestableTab: AnyObject {
    func tabBarControllerWillDeselectTab(_ tabBarController: TabBarController)
}

protocol TabBarView: AnyObject {
    func select(tab: TabBarPage, popToRoot: Bool)
}

public final class TabBarController: UITabBarController, TabBarView {
    // MARK: Parameters

    var presenter: TabBarPresenter?

    private(set) var tabBarStyle: TabBarStyle = .rounded

    // MARK: - Lifecycle

    override public func loadView() {
        super.loadView()
        self.setValue(RoundedTabbar(), forKey: "tabBar")
    }

    override public var selectedViewController: UIViewController? {
        didSet {
            updateStyle(.rounded)
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.enter()
    }
}

// MARK: - Public

public extension TabBarController {
    func updateStyle(_ style: TabBarStyle) {
        guard
            let tabbar = tabBar as? RoundedTabbar,
            style != tabBarStyle
        else {
            return
        }

        tabBarStyle = style

        switch style {
        case .simple:
            tabbar.style = .simple

        case .rounded:
            tabbar.style = .rounded
        }
    }

    func setItems(_ items: [RoundedTabItem]) {
        guard let tabBar = self.tabBar as? RoundedTabbar else { return }

        tabBar.setItems(items)
    }

    func select(
        tab: TabBarPage,
        popToRoot: Bool = false
    ) {
        let shouldResetTab = self.selectedIndex == tab.rawValue

        if popToRoot == false, shouldResetTab == false {
            let nestableTab: NestableTab?
            let selectedViewController = viewControllers?[selectedIndex]
            switch selectedViewController {
            case let selectedViewController as UINavigationController:
                nestableTab = selectedViewController.topViewController as? NestableTab

            default:
                nestableTab = selectedViewController as? NestableTab
            }
            nestableTab?.tabBarControllerWillDeselectTab(self)
        }

        selectedIndex = tab.rawValue
        selectedViewController = viewControllers?[tab.rawValue]

        if popToRoot || shouldResetTab {
            resetSelectedTabToRootController()
        }

        if let vc = self.selectedViewController {
            delegate?.tabBarController?(self, didSelect: vc)
        }

        updateTabBar()
    }

    func resetSelectedTabToRootController(animated: Bool = true) {
        let currentController = selectedViewController
        let navController = currentController as? UINavigationController

        currentController?.presentedViewController?.dismiss(animated: animated) { [weak self] in
            if currentController?.presentedViewController != nil {
                // повторяем, пока не закроем все модальные экраны
                self?.resetSelectedTabToRootController(animated: animated)
            }
        }

        navController?.popToRootViewController(animated: animated)

        tabBar.isHidden = false
    }

    func updateTabBar() {
        let tabs = makeTabs()
        setItems(tabs)
    }

    func makeTabs() -> [RoundedTabItem] {
        var tabs: [RoundedTabItem] = []

        for (index, tab) in TabBarPage.allCases.enumerated() {
            let isSelected = selectedIndex == tab.rawValue
            let selectionState: TabBarPageState = isSelected ? .selected : .unselected

            let tabItem = RoundedTabItem(
                title: tab.getTitle(),
                icon: tab.getIcon(for: selectionState),
                state: selectionState,
                action: { [weak self] tab in
                    self?.select(tab: tab)
                },
                index: index
            )

            tabs.append(tabItem)
        }

        return tabs
    }
}

// MARK: - Constants

extension TabBarController {
    private enum Animation {
        static let duration: Double = 0.2

        static let options: UIView.AnimationOptions = [
            .allowAnimatedContent,
            .beginFromCurrentState,
            .curveEaseInOut
        ]
    }

    public enum TabBarStyle: Equatable {
        /// Стиль таббара без закругления
        case simple

        /// Стиль таббара, есть закругление верхних углов
        case rounded
    }
}
