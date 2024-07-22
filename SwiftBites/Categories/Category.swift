//
//  Category.swift
//  SwiftBites
//
//  Created by Saurav Verma on 22/07/24.
//

import Foundation
import SwiftData

@Model
final class Category: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var recipes: [Recipe]

    init(
        id: UUID = UUID(),
        name: String = "",
        recipes: [Recipe] = []
    ) {
        self.id = id
        self.name = name
        self.recipes = recipes
    }

    // MARK: - Hashable Conformance
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: - Codable Conformance
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case recipes
    }

    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(recipes, forKey: .recipes)
    }

    // Decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.recipes = try container.decode([Recipe].self, forKey: .recipes)
    }
}
