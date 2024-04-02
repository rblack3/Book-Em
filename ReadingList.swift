import SwiftUI
import SwiftData

struct ReadingList: View {
  @Environment(\.modelContext) private var modelContext
  @Query(filter: #Predicate<Book> { book in
      book.readingList == true
  }, sort: \Book.title)
    private var books: [Book] = Book.previewData

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    BookRow(book: book)
                        .swipeActions {
                            Button("Delete") {
                                toggleReadingList(for: book)
                            }
                            .tint(.red)
                        }
                }
                .onDelete { indexSet in
                    books[indexSet.first!].readingList = false
                }
            }
        }
        .navigationTitle("Reading List")
        .font(.largeTitle)
        .bold()
    }

    private func toggleReadingList(for book: Book) {
        book.readingList.toggle()
        try? modelContext.save()
    }

}

#Preview {
  let preview = PreviewContainer([Book.self])
  preview.add(items: Book.previewData)
  return
    ReadingList()
      .modelContainer (preview.container)
}
