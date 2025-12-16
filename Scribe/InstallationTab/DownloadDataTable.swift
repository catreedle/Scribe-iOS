// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * The data table for the Download data screen of the Scribe app.
 */

import Foundation

struct DownloadDataTable {
  static var downloadDataTable: [ParentTableCellModel] {
    [
      // Section 1: Update data
      ParentTableCellModel(
        headingTitle: "Update data",
        section: [
          Section(sectionTitle: "Check for new data", imageString: "checkmark.icloud", hasToggle: true, sectionState: .checkData),
          Section(sectionTitle: "Regularly update Scribe data", imageString: "gear", hasToggle: true, sectionState: .matrix)
        ],
        hasDynamicData: nil
      ),

      // Section 2: Download language data (dynamic from installed keyboards)
      ParentTableCellModel(
        headingTitle: "Select data to download",
        section: SettingsTableData.getInstalledKeyboardsSections().map { keyboard in
          Section(
            sectionTitle: keyboard.sectionTitle,
            imageString: keyboard.imageString,
            hasToggle: keyboard.hasToggle,
            sectionState: .languageDownload,
            shortDescription: keyboard.shortDescription
          )
        },
        hasDynamicData: nil
      )
    ]
  }
}
