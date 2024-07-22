//
//  RecipeIngredient.swift
//  SwiftBites
//
//  Created by Saurav Verma on 22/07/24.
//


import Foundation
import SwiftData

@Model
final class RecipeIngredient: Identifiable, Hashable, Codable {
    let id: UUID
    var ingredient: Ingredient
    var quantity: String

    init(
        id: UUID = UUID(),
        ingredient: Ingredient = Ingredient(),
        quantity: String = ""
    ) {
        self.id = id
        self.ingredient = ingredient
        self.quantity = quantity
    }

    // MARK: - Hashable Conformance
    static func == (lhs: RecipeIngredient, rhs: RecipeIngredient) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: - Codable Conformance
    enum CodingKeys: String, CodingKey {
        case id
        case ingredient
        case quantity
    }

    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(ingredient, forKey: .ingredient)
        try container.encode(quantity, forKey: .quantity)
    }

    // Decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.ingredient = try container.decode(Ingredient.self, forKey: .ingredient)
        self.quantity = try container.decode(String.self, forKey: .quantity)
    }
}
