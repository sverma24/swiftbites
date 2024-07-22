
import SwiftUI
import SwiftData

struct CategoryForm: View {
    @Environment (\.modelContext) var modelContext
    @Query var categories: [Category]
    @Query var recipes: [Recipe]
    @Bindable var category: Category
    
    enum CategoryError: LocalizedError {
        case categoryExists
        
        var errorDescription: String? {
            return "Category with the same name exists"
        }
    }
    
    enum Mode: Hashable {
        case add
        case edit(Category)
    }
    
    var mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        self.category = Category(id: UUID(), name: "")
        switch mode {
        case .add:
            _name = .init(initialValue: "")
            title = "Add Category"
        case .edit(let category):
            _name = .init(initialValue: category.name)
            title = "Edit \(category.name)"
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
            if case .edit(let category) = mode {
                Button(
                    role: .destructive,
                    action: {
                        delete(category: category)
                    },
                    label: {
                        Text("Delete Category")
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
        .alert(error: $error)
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
    
    func delete(category: Category) {
        modelContext.delete(category)
        dismiss()
    }
    
    func addCategory(name: String) throws {
      guard categories.contains(where: { $0.name == name }) == false else {
        throw CategoryError.categoryExists
      }
        modelContext.insert(category)
    }
    
    func updateCategory(id: Category.ID, name: String) throws {
      guard categories.contains(where: { $0.name == name && $0.id != id }) == false else {
        throw CategoryError.categoryExists
      }
      guard let index = categories.firstIndex(where: { $0.id == id }) else {
        return
      }
      categories[index].name = name
      for (index, recipe) in recipes.enumerated() where recipe.category?.id == id {
        recipes[index].category?.name = name
      }
    }
    
    private func save() {
        do {
            switch mode {
            case .add:
                category.name = name
                try addCategory(name: category.name)
            case .edit(let category):
                try updateCategory(id: category.id, name: name)
            }
            dismiss()
        } catch {
            self.error = error
        }
    }
}
