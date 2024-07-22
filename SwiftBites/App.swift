import SwiftUI
import SwiftData

@main
struct SwiftBitesApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: [
        Ingredient.self,
        Category.self,
        Recipe.self,
        RecipeIngredient.self
    ])
  }
}
