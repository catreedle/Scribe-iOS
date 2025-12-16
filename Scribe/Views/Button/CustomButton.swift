// SPDX-License-Identifier: GPL-3.0-or-later

import UIKit

/// Reusable custom button component
class CustomButton: UIButton {

  private var action: (() -> Void)?

  init(
    title: String = "Button",
    backgroundColor: UIColor = .systemBlue,
    titleColor: UIColor = .white,
    icon: UIImage? = nil,
    cornerRadius: CGFloat = 8
  ) {
    super.init(frame: .zero)
    setupButton(
      title: title,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      icon: icon,
      cornerRadius: cornerRadius
    )
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupButton(
    title: String,
    backgroundColor: UIColor,
    titleColor: UIColor,
    icon: UIImage?,
    cornerRadius: CGFloat
  ) {
    translatesAutoresizingMaskIntoConstraints = false

    var config = UIButton.Configuration.filled()
    config.title = title
    config.baseBackgroundColor = backgroundColor
    config.baseForegroundColor = titleColor
    config.cornerStyle = .medium
    config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)

    // Icon placement di kanan
    if let icon = icon {
      config.image = icon.withRenderingMode(.alwaysTemplate)
      config.imagePlacement = .trailing
      config.imagePadding = 8
    }

    configuration = config
    layer.cornerRadius = cornerRadius

    addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }

  /// Update button properties
  func updateButton(
    title: String? = nil,
    backgroundColor: UIColor? = nil,
    titleColor: UIColor? = nil,
    icon: UIImage? = nil
  ) {
    var config = configuration ?? UIButton.Configuration.filled()

    if let title = title {
      config.title = title
    }
    if let backgroundColor = backgroundColor {
      config.baseBackgroundColor = backgroundColor
    }
    if let titleColor = titleColor {
      config.baseForegroundColor = titleColor
    }
    if let icon = icon {
      config.image = icon.withRenderingMode(.alwaysTemplate)
      config.imagePlacement = .trailing
      config.imagePadding = 8
    }

    configuration = config
  }

  func setAction(_ action: @escaping () -> Void) {
    self.action = action
  }

  @objc private func buttonTapped() {
    action?()
  }
}
