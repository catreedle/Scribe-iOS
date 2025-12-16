// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Controls data displayed in the Installation tab.
 */

import Foundation

struct InstallationTableData {
  static var installationTableData = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.download.menu_option.scribe_title", value: "Language data", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.download.menu_option.scribe_download_data", value: "Download keyboard data", comment: ""),
          sectionState: .downloadData,
          shortDescription: NSLocalizedString("app.download.menu_option.scribe_description", value: "Add new data to Scribe keyboards.", comment: "")
        )],
      hasDynamicData: nil)
  ]
}
