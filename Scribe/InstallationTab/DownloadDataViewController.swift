// SPDX-License-Identifier: GPL-3.0-or-later

import UIKit

/**
 * Protocol for cells that support rounded corners
 */
protocol RoundableCell {
  func applyCornerRadius(corners: CACornerMask, radius: CGFloat)
  func removeCornerRadius()
}

extension DownloadLanguageCell: RoundableCell {}
extension InfoChildWrapperCell: RoundableCell {}

/**
 * ViewController for Download Language Data screen
 */
final class DownloadDataViewController: BaseTableViewController {
  override var dataSet: [ParentTableCellModel] {
    tableData
  }

  private var tableData: [ParentTableCellModel] = []
  private let sectionHorizontalPadding: CGFloat = 16
  private let cornerRadius: CGFloat = 12

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Download Data"

    // Enable large titles
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always

    tableView.backgroundColor = scribeAppBackgroundColor
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 80
    tableView.separatorStyle = .none

    // Register cells
    tableView.register(DownloadLanguageCell.self, forCellReuseIdentifier: DownloadLanguageCell.reuseIdentifier)
    tableView.register(InfoChildWrapperCell.self, forCellReuseIdentifier: InfoChildWrapperCell.reuseIdentifier)
  }

  func configureTable(for data: [ParentTableCellModel]) {
    self.tableData = data
  }

  // MARK: - Helper Methods

  private func applyCornerRadius(to cell: UITableViewCell, isFirst: Bool, isLast: Bool) {
    guard let roundableCell = cell as? RoundableCell else { return }

    if isFirst && isLast {
      roundableCell.applyCornerRadius(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: cornerRadius)
    } else if isFirst {
      roundableCell.applyCornerRadius(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: cornerRadius)
    } else if isLast {
      roundableCell.applyCornerRadius(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: cornerRadius)
    } else {
      roundableCell.removeCornerRadius()
    }
  }
}

// MARK: UITableViewDataSource

extension DownloadDataViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = tableData[indexPath.section].section[indexPath.row]
    let isFirstRow = indexPath.row == 0
    let isLastRow = indexPath.row == tableData[indexPath.section].section.count - 1

    let cell: UITableViewCell

    if section.sectionState == .languageDownload {
      guard let downloadCell = tableView.dequeueReusableCell(
        withIdentifier: DownloadLanguageCell.reuseIdentifier,
        for: indexPath
      ) as? DownloadLanguageCell else {
        fatalError("Failed to dequeue DownloadLanguageCell")
      }

      let downloadIcon = UIImage(systemName: "icloud.and.arrow.down")
      downloadCell.configure(
        language: section.sectionTitle,
        buttonTitle: "Download data",
        buttonBackgroundColor: scribeCTAColor,
        buttonTitleColor: .black,
        buttonIcon: downloadIcon
      ) {
        print("Download: \(section.sectionTitle)")
        self.handleDownload(for: section)
      }

      cell = downloadCell
    } else {
      guard let wrapperCell = tableView.dequeueReusableCell(
        withIdentifier: InfoChildWrapperCell.reuseIdentifier,
        for: indexPath
      ) as? InfoChildWrapperCell else {
        fatalError("Failed to dequeue InfoChildWrapperCell")
      }

      wrapperCell.configure(with: section)
      cell = wrapperCell
    }

    applyCornerRadius(to: cell, isFirst: isFirstRow, isLast: isLastRow)
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  private func handleDownload(for section: Section) {
    let alert = UIAlertController(
      title: "Download \(section.sectionTitle)",
      message: "Download data for \(section.sectionTitle)?",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Download", style: .default))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
  }
}

// MARK: UITableViewDelegate

extension DownloadDataViewController {
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView: UIView

    if let reusableHeaderView = tableView.headerView(forSection: section) {
      headerView = reusableHeaderView
    } else {
      headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 32))
    }

    let labelXPosition: CGFloat
    if preferredLanguage.prefix(2) == "ar" {
      labelXPosition = -1 * headerView.bounds.width / 10
    } else {
      // Use table view's separator inset for consistent alignment
      labelXPosition = tableView.separatorInset.left
    }

    let label = UILabel(
      frame: CGRect(
        x: labelXPosition,
        y: 0,
        width: headerView.bounds.width - labelXPosition,
        height: 32
      )
    )

    label.text = dataSet[section].headingTitle
    label.font = UIFont.boldSystemFont(ofSize: fontSize * 1.1)
    label.textColor = keyCharColor
    headerView.addSubview(label)

    return headerView
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
}
