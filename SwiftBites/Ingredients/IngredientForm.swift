import SwiftUI
import SwiftData

struct IngredientForm: View {
    @Environment (\.modelContext) var modelContext
    @Query var ingredients: [Ingredient]
    @Bindable var ingredient: Ingredient
    
    enum IngredientError: LocalizedError {
        case ingredientExists
        
        var errorDescription: String? {
            return "Ingredient with the same name exists"
        }
    }
    
    enum Mode: Hashable {
        case add
        case edit(Ingredient)
    }
    
    var mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        self.ingredient = Ingredient(id: UUID(), name: "")
        switch mode {
        case .add:
            _name = .init(initialValue: "")
            title = "Add Ingredient"
        case .edit(let ingredient):
            _name = .init(initialValue: ingredient.name)
            title = "Edit \(ingredient.name)"
        }
    }



  private let title: String
  @State private var name: String
  @State private var error: Error?
  @Environment(\.dismiss) private var dismiss
  @FocusState private var isNameFocused: Bool

  // MARK: - Body

  var body: some View {
    Form {
      Section {
        TextField("Name", text: $name)
          .focused($isNameFocused)
      }
      if case .edit(let ingredient) = mode {
        Button(
          role: .destructive,
          action: {
            delete(ingredient: ingredient)
          },
          label: {
            Text("Delete Ingredient")
              .frame(maxWidth: .infinity, alignment: .center)
          }
        )
      }
    }
    .onAppear {
      isNameFocused = true
    }
    .onSubmit {
      save()
    }
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save", action: save)
          .disabled(name.isEmpty)
      }
    }
  }

  // MARK: - Data
    
    func delete(ingredient: Ingredient) {
        modelContext.delete(ingredient)
        dismiss()
    }

  private func save() {
    do {
      switch mode {
      case .add:
          ingredient.name = name
          try addIngredient(name: ingredient.name)
      case .edit(let ingredient):
        try updateIngredient(id: ingredient.id, name: name)
      }
      dismiss()
    } catch {
      self.error = error
    }
  }
    
    func addIngredient(name: String) throws {
      guard ingredients.contains(where: { $0.name == name }) == false else {
        throw IngredientError.ingredientExists
      }
        modelContext.insert(ingredient)
    }
    
    func updateIngredient(id: Ingredient.ID, name: String) throws {
      guard ingredients.contains(where: { $0.name == name && $0.id != id }) == false else {
        throw IngredientError.ingredientExists
      }
      guard let index = ingredients.firstIndex(where: { $0.id == id }) else {
        return
      }
      ingredients[index].name = name
    }
    
}
