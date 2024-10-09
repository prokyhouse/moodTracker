//
//  AddReportView.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Design
import Domain
import UIKit

protocol AddReportView: AnyObject {
    func setTitle(_ title: String)

    func setQuestionBubbleText(_ text: NSAttributedString, emoji: UIImage?)

    func setUserBubbleText(_ text: NSAttributedString, emoji: UIImage?, isAnimated: Bool)

    func displayMoodAppearance(backgroundColor: UIColor, isAnimated: Bool)

    func setMoodSliderValue(_ value: Int)
}

final class AddReportViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: AddReportPresenter?

    // MARK: - Private properties

    // MARK: - Views

    private lazy var navBar: NavigationBar = {
        let navBar = NavigationBar()
        navBar.delegate = self
        navBar.isBackButtonHidden = false
        return navBar
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = Constants.saveButtonHeight / 2
        button.backgroundColor = AppResources.colors.background
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = AppResources.fonts.bgProFonts.bold.ofSize(17)
        button.setTitle("Добавить", for: .normal)

        return button
    }()

    private lazy var moodSlider: MoodSlider = {
        let slider = MoodSlider()
        slider.minimumValue = Float(MoodType.melancholic.rawValue)
        slider.maximumValue = Float(MoodType.starStruck.rawValue)
        slider.isContinuous = true

        return slider
    }()

    private lazy var questionBubbleView: BubbleView = {
        BubbleView()
    }()

    private lazy var userBubbleView: BubbleView = {
        BubbleView()
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        setupViews()

        self.tabBarController?.tabBar.isHidden = true

        presenter?.onViewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.onViewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }

    @objc
    func sliderValueDidChange(sender: UISlider) {
        let roundedValue = round(sender.value)
        presenter?.onSliderValueDidChange(value: roundedValue)
    }

    @objc
    func saveButtonDidTap() {
        presenter?.onSaveButtonTapped()
        presenter?.leave(completion: { [weak self] in
            guard let self else { return }
            self.tabBarController?.tabBar.isHidden = false
        })
    }
}

// MARK: - Private methods

private extension AddReportViewController {
    func addSubviews() {
        view.addSubviews(navBar, saveButton, questionBubbleView, userBubbleView, moodSlider)

        view.bringSubviewToFront(navBar)
    }

    func setupConstraints() {
        extendedLayoutIncludesOpaqueBars = true
        view.layoutMargins = Constants.innerMargins

        NSLayoutConstraint.useAndActivateConstraints([
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalSpacing * 2),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalSpacing * 2),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.saveButtonHeight),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.spacing)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            questionBubbleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            questionBubbleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalSpacing),
            questionBubbleView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 40.0)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            userBubbleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalSpacing),
            userBubbleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            userBubbleView.topAnchor.constraint(equalTo: questionBubbleView.bottomAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            moodSlider.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -64.0),
            moodSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalSpacing * 2),
            moodSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalSpacing * 2),
            moodSlider.heightAnchor.constraint(equalToConstant: 33.0)
        ])
    }

    func setupViews() {
        view.backgroundColor = AppResources.colors.background

        moodSlider.addTarget(self, action:#selector(sliderValueDidChange(sender:)), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
    }
}

// MARK: - AddReportView

extension AddReportViewController: AddReportView {
    func setTitle(_ title: String) {
        navBar.title = title
    }

    func setQuestionBubbleText(_ text: NSAttributedString, emoji: UIImage?) {
        questionBubbleView.render(
            with:
                BubbleView.Props(
                    type: .right,
                    text: text,
                    icon: emoji
                )
        )
    }

    func setUserBubbleText(_ text: NSAttributedString, emoji: UIImage?, isAnimated: Bool) {
        let animationDuration = isAnimated ? 0.8 : 0
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self else { return }
            userBubbleView.render(
                with:
                    BubbleView.Props(
                        type: .left,
                        text: text,
                        icon: emoji
                    )
            )
        }
    }

    func displayMoodAppearance(backgroundColor: UIColor, isAnimated: Bool) {
        let animationDuration = isAnimated ? 0.8 : 0
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self else { return }
            view.backgroundColor = backgroundColor
            saveButton.setTitleColor(backgroundColor, for: .normal)
        }
    }

    func setMoodSliderValue(_ value: Int) {
        moodSlider.value = Float(value)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AddReportViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = MoodCell.Constants.height
        let width = UIScreen.main.bounds.width - Constants.spacing * 2
        return CGSize(width: width, height: height)
    }
}

// MARK: - NavigationBarDelegate

extension AddReportViewController: NavigationBarDelegate {
    func didReceiveBackAction(_ navigationBar: NavigationBar) {
        presenter?.leave(completion: { [weak self] in
            guard let self else { return }
            self.tabBarController?.tabBar.isHidden = false
        })
    }
}

// MARK: - Constants

private extension AddReportViewController {
    enum Constants {
        static let spacing: CGFloat = 8.0
        static let cornerRadius: CGFloat = 24.0
        static let horizontalSpacing: CGFloat = 16.0
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .zero
        static let saveButtonHeight: CGFloat = 50.0
    }
}
