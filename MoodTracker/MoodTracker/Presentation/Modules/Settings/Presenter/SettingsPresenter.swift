//
//  SettingsPresenter.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Domain
import Design
import UIKit

protocol SettingsPresenter: AnyObject {
    var isSystemAppearance: Bool { get }
    var neededAppearance: UIUserInterfaceStyle { get }
    var currentAppearance: UIUserInterfaceStyle { get }

    func onViewDidLoad()

    func changeAppearanceTo(_ appearance: UIUserInterfaceStyle)

    func leave()
}

final class SettingsViewPresenter {
    // MARK: - Private Properties

    private unowned let view: SettingsView
    private let coordinator:SettingsCoordinator

    // MARK: - Lifecycle

    init(
        view: SettingsView,
        coordinator: SettingsCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - SettingsPresenter

extension SettingsViewPresenter: SettingsPresenter {

    var isSystemAppearance: Bool { getNeededAppearance() == .unspecified }
    var neededAppearance: UIUserInterfaceStyle { getNeededAppearance() }
    var currentAppearance: UIUserInterfaceStyle { getCurrentAppearance() }

    func onViewDidLoad() {
        view.setTitle(Constants.title)
        updateAppVersionLabel()
    }

    func changeAppearanceTo(_ appearance: UIUserInterfaceStyle) {
        AppResources.appearance.change(to: appearance)
    }

    func leave() {
        coordinator.goBack()
    }
}

// MARK: - Private Methods

private extension SettingsViewPresenter {
    func getCurrentAppearance() -> UIUserInterfaceStyle {
        AppResources.appearance.getCurrentAppearance()
    }

    func getNeededAppearance() -> UIUserInterfaceStyle {
        AppResources.appearance.getNeededAppearance()
    }

    func updateAppVersionLabel() {
        var versionString = String()

        if let appVersion = getAppVersion(), let buildNumber = getAppBuild()  {
            versionString = "Build \(appVersion) (\(buildNumber))"
        }

        view.setAppVersion(string: versionString)
    }

    func getAppVersion() -> String? {
        guard
            let infoDictionary = Bundle.main.infoDictionary,
            let version = infoDictionary[Constants.appVersionDictionaryKey] as? String
        else {
            return nil
        }

        return version
    }

    func getAppBuild() -> String? {
        guard
            let infoDictionary = Bundle.main.infoDictionary,
            let build = infoDictionary[Constants.buildNumberDictionaryKey] as? String
        else {
            return nil
        }
        return build
    }
}

// MARK: - Constants

private extension SettingsViewPresenter {
    enum Constants {
        static let title = "Настройки"
        static let appVersionDictionaryKey: String = "CFBundleShortVersionString"
        static let buildNumberDictionaryKey: String = "CFBundleVersion"
    }
}
