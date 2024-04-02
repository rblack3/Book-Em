import SwiftUI

struct TabContainer: View {
  
  var body: some View {
    TabView{
      NavigationStack {
        BookList()
      }
      .tabItem {
        Label("Books", systemImage: "book")
      }
      NavigationStack {
        ReadingList()
      }
      .tabItem {
        Label("Reading List", systemImage: "list.star")
      }
    }
  }
}


#Preview {
  let preview = PreviewContainer([Book.self])
  preview.add(items: Book.previewData)
  return
    TabContainer()
      .modelContainer (preview.container)
}


