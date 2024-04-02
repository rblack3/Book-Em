import SwiftUI
import SwiftData

struct BookList: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Book.title) private var books: [Book] = Book.previewData
  @State private var isPresentingBookForm: Bool = false
  @State private var newBookFormData = Book.FormData()

    var body: some View {
        NavigationView {
            List(books) { book in
                NavigationLink(destination: BookDetail(book: book, synopsisLoader: SynopsisLoader(apiClient: OpenLibraryAPIClient()))) {
                    BookRow(book: book)
                }
            }
            .sheet(isPresented: $isPresentingBookForm) {
                NavigationStack {
                    BookForm(book: $newBookFormData)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") { isPresentingBookForm.toggle() }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Save") {
                                    Book.create(from: newBookFormData, context: modelContext)
                                    isPresentingBookForm.toggle()
                                }
                            }
                        }
                }
            }
            .font(.subheadline)
            .bold(false)
        }
        .navigationTitle("Books - rhb22")
        .font(.largeTitle)
        .bold()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    isPresentingBookForm.toggle()
                }
            }
        }
        .onAppear {
            if books.isEmpty {
                for book in Book.previewData {
                    modelContext.insert(book)
                }
            }
        }
    }
}


struct BookRow: View {
    @Environment(\.modelContext) private var modelContext
    let book: Book
    
    var body: some View {
        HStack {
            if let coverUrl = book.coverUrl {
                AsyncImage(url: coverUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .cornerRadius(6.0)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 50)
                    case .failure:
                        Image(systemName: "book")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 32, maxHeight: 30)
                    @unknown default:
                        ProgressView()
                    }
                }
            } else {
                Image(systemName: "book")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 32, maxHeight: 30)
            }
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                    .bold()
                Text(book.author)
                    .font(.subheadline)
                    .bold(false)
            }
        }
    }
}

#Preview {
  let preview = PreviewContainer([Book.self])
  preview.add(items: Book.previewData)
  return
    BookList()
      .modelContainer (preview.container)
}
