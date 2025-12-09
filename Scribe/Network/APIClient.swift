// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Functions relating to API calls
 */

import Foundation

enum APIClient {
  static func fetchLanguageData(langCode: String) async throws -> LanguageData {
    let url = URL(string: "https://scribe-server.toolforge.org/api/v1/data/" + langCode)!

    let (data, _) = try await URLSession.shared.data(from: url)
    let decoded = try JSONDecoder().decode(LanguageData.self, from: data)

    return decoded

  }
}

struct LanguageData: Decodable {
  let contract: Contract
  let data: [String: [[String: String?]]]
  let language: String
}

struct Contract: Decodable {
  let fields: [String: [String: String]]
  let updatedAt: String
  let version: String

  enum CodingKeys: String, CodingKey {
    case fields
    case updatedAt = "updated_at"
    case version
  }
}
