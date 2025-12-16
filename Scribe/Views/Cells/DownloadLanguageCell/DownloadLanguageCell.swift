// SPDX-License-Identifier: GPL-3.0-or-later

import UIKit

class DownloadLanguageCell: UITableViewCell {
  static let reuseIdentifier = "DownloadLanguageCell"

  private let containerView = UIView()
  private let languageLabel = UILabel()
  private let actionButton = CustomButton()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    selectionStyle = .none

    // Container view dengan padding
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.backgroundColor = lightWhiteDarkBlackColor
    contentView.addSubview(containerView)

    // Language label
    languageLabel.translatesAutoresizingMaskIntoConstraints = false
    languageLabel.font = UIFont.systemFont(ofSize: 16)
    containerView.addSubview(languageLabel)

    // Action button (using CustomButton component)
    containerView.addSubview(actionButton)

    NSLayoutConstraint.activate([
      // Container dengan horizontal padding
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      // Language label
      languageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      languageLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

      // Action button
      actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      actionButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      actionButton.heightAnchor.constraint(equalToConstant: 32),

      languageLabel.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -8)
    ])
  }

  func configure(
    language: String,
    buttonTitle: String = "Download",
    buttonBackgroundColor: UIColor = .systemBlue,
    buttonTitleColor: UIColor = .white,
    buttonIcon: UIImage? = nil,
    action: @escaping () -> Void
  ) {
    languageLabel.text = language

    // Update button menggunakan CustomButton component
    actionButton.updateButton(
      title: buttonTitle,
      backgroundColor: buttonBackgroundColor,
      titleColor: buttonTitleColor,
      icon: buttonIcon
    )
    actionButton.setAction(action)
  }

  func applyCornerRadius(corners: CACornerMask, radius: CGFloat) {
    containerView.layer.maskedCorners = corners
    containerView.layer.cornerRadius = radius
    containerView.layer.masksToBounds = true
  }

  func removeCornerRadius() {
    containerView.layer.cornerRadius = 0
    containerView.layer.masksToBounds = false
  }
}
