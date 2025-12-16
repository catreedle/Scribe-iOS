// SPDX-License-Identifier: GPL-3.0-or-later

import UIKit

/// Wrapper cell for InfoChildTableViewCell with padding and corner radius support
class InfoChildWrapperCell: UITableViewCell {
  static let reuseIdentifier = "InfoChildWrapperCell"

  private let containerView = UIView()
  private var infoCell: InfoChildTableViewCell?

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

    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.backgroundColor = lightWhiteDarkBlackColor
    contentView.addSubview(containerView)

    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  func configure(with section: Section) {
    // Remove old infoCell if exists
    infoCell?.removeFromSuperview()

    // Load InfoChildTableViewCell from XIB
    guard let cell = Bundle.main.loadNibNamed(
      "InfoChildTableViewCell",
      owner: nil,
      options: nil
    )?.first as? InfoChildTableViewCell else {
      fatalError("Failed to load InfoChildTableViewCell from XIB")
    }

    cell.configureCell(for: section)
    cell.backgroundColor = .clear
    cell.translatesAutoresizingMaskIntoConstraints = false

    containerView.addSubview(cell)

    NSLayoutConstraint.activate([
      cell.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      cell.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      cell.topAnchor.constraint(equalTo: containerView.topAnchor),
      cell.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])

    infoCell = cell
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
