// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Managing the download process of the Scribe app.
 */

import Foundation
import GRDB

enum DownloadManager {

  static let appGroupID = "group.be.scri.userDefaultsContainer"

  // Database URL
  static func databaseURL(language: String) -> URL {
    let fm = FileManager.default
    guard let containerURL = fm.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
    else { fatalError("App Group container not found") }
    return containerURL.appendingPathComponent("\(language).sqlite")
  }

  static func writeDBFile(language: String) {
    let dbURL = databaseURL(language: "\(language)LanguageTestDB")

    if FileManager.default.fileExists(atPath: dbURL.path) {
      print("DB already exists at:", dbURL.path)
      return
    }
  }

  // Open or create database queue
  static func openDatabase(language: String) throws -> DatabaseQueue {
    let dbURL = databaseURL(language: "\(language)LanguageTestDB")
    return try DatabaseQueue(path: dbURL.path)
  }

  // Create table from a field dictionary
  static func createTable(db: Database, tableName: String, fields: [String: String]) throws {
    try db.create(table: tableName, ifNotExists: true) { t in
      for (field, _) in fields {
        t.column(field, .text)
      }
    }
  }

  // Insert a row dictionary into a table
  static func insertRow(db: Database, tableName: String, row: [String: String?]) throws {
    var columns = [String]()
    var values = [DatabaseValueConvertible]()

    for (k, v) in row {
      columns.append(k)
      values.append(v)
    }

    let sql = "INSERT INTO \(tableName) (\(columns.joined(separator: ","))) VALUES (\(Array(repeating: "?", count: values.count).joined(separator: ",")))"
    try db.execute(sql: sql, arguments: StatementArguments(values))
  }
}
