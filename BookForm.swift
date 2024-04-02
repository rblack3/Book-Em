import SwiftUI

struct BookForm: View {
    @Environment(\.modelContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var book: Book.FormData

    var body: some View {
        NavigationView {
            Form {
                TextFieldWithLabel(label: "ID", text: $book.id, prompt: "ID")
                TextFieldWithLabel(label: "Title", text: $book.title, prompt: "Ex. Call Of The Wild")
                TextFieldWithLabel(label: "Author", text: $book.author, prompt: "Ex. John Deere")
            }
        }
    }
    
    private func clearFormData() {
        book.id = ""
        book.title = ""
        book.author = ""
    }
}
