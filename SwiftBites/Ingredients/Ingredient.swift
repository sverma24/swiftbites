//
//  Ingredient.swift
//  SwiftBites
//
//  Created by Saurav Verma on 22/07/24.
//

import Foundation
import SwiftData

@Model
final class Ingredient: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String

    init(id: UUID = UUID(), name: String = "") {
        self.id = UUID()
        self.name = name
    }

    // MARK: - Hashable Conformance
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: - Codable Conformance
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }

    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

