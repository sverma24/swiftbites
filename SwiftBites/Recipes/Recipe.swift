//
//  Recipe.swift
//  SwiftBites
//
//  Created by Saurav Verma on 22/07/24.
//
 import Foundation
 import SwiftData
 
 @Model
 final class Recipe: Identifiable, Hashable, Codable {
 var id: UUID
 var name: String
 var summary: String
 var category: Category?
 var serving: Int
 var time: Int
 var ingredients: [RecipeIngredient]
 var instructions: String
 var imageData: Data?
 
 init(
 id: UUID = UUID(),
 name: String = "",
 summary: String = "",
 category: Category? = nil,
 serving: Int = 1,
 time: Int = 5,
 ingredients: [RecipeIngredient] = [],
 instructions: String = "",
 imageData: Data? = nil
 ) {
 self.id = id
 self.name = name
 self.summary = summary
 self.category = category
 self.serving = serving
 self.time = time
 self.ingredients = ingredients
 self.instructions = instructions
 self.imageData = imageData
 }
 
 // MARK: - Hashable Conformance
 static func == (lhs: Recipe, rhs: Recipe) -> Bool {
 lhs.id == rhs.id
 }
 
 func hash(into hasher: inout Hasher) {
 hasher.combine(id)
 }
 
 // MARK: - Codable Conformance
 enum CodingKeys: String, CodingKey {
 case id
 case name
 case summary
 case category
 case serving
 case time
 case ingredients
 case instructions
 case imageData
 }
 
 // Encoding
 func encode(to encoder: Encoder) throws {
 var container = encoder.container(keyedBy: CodingKeys.self)
 try container.encode(id, forKey: .id)
 try container.encode(name, forKey: .name)
 try container.encode(summary, forKey: .summary)
 try container.encode(category, forKey: .category)
 try container.encode(serving, forKey: .serving)
 try container.encode(time, forKey: .time)
 try container.encode(ingredients, forKey: .ingredients)
 try container.encode(instructions, forKey: .instructions)
 try container.encode(imageData, forKey: .imageData)
 }
 
 // Decoding
 required init(from decoder: Decoder) throws {
 let container = try decoder.container(keyedBy: CodingKeys.self)
 self.id = try container.decode(UUID.self, forKey: .id)
 self.name = try container.decode(String.self, forKey: .name)
 self.summary = try container.decode(String.self, forKey: .summary)
 self.category = try container.decodeIfPresent(Category.self, forKey: .category)
 self.serving = try container.decode(Int.self, forKey: .serving)
 self.time = try container.decode(Int.self, forKey: .time)
 self.ingredients = try container.decode([RecipeIngredient].self, forKey: .ingredients)
 self.instructions = try container.decode(String.self, forKey: .instructions)
 self.imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
 }
 }
