import Foundation
import SwiftUI

struct BookDetail: View {
    @Bindable var book: Book
    @State var synopsisLoader: SynopsisLoader
    @State var synop: String = ""
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    if let coverUrl = book.coverUrl {
                        AsyncImage(url: coverUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                            case .failure:
                                Image(systemName: "book")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 32, maxHeight: 30)
                            @unknown default:
                                ProgressView()
                            }
                        }
                        .frame(maxHeight: 200)
                    } else {
                        Image(systemName: "book")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 32, maxHeight: 30)
                    }
                    Spacer()
                }
                VStack {
                    HStack {
                        Spacer()
                        Text(book.title)
                            .font(.title)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text(book.author)
                            .font(.caption)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("Reading List")
                        Spacer()
                        Toggle("", isOn: $book.readingList)
                        Spacer()
                    }
                    switch synopsisLoader.state {
                    case .idle: Color.clear
                    case .loading: ProgressView()
                    case .failed(let error): Text("Could Not Load Synopsis")
                    case .success(let synop):
                        Text(synop)
                    }
                }
            }
            .padding()
            .onAppear() {
                if synop == "" {
                    Task {
                        await synopsisLoader.loadSynopsis(from: book.id)
                    }
                }
                switch synopsisLoader.state {
                case .idle: Color.clear
                case .loading: ProgressView()
                case .failed(let error): synop = "Could Not Load Synopsis"
                case .success(let summary): synop = summary
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if book.readingList {
                    Button("Remove From List") {
                        book.readingList.toggle()
                    }
                } else {
                    Button("Add to List") {
                        book.readingList.toggle()
                    }
                }
            }
        }
    }
}

@Observable
class SynopsisLoader {
  let apiClient: OpenLibraryAPI
  private(set) var state: LoadingState = .idle
  var synopsis: String?

  enum LoadingState {
    case idle
    case loading
    case success(data: String)
    case failed(error: Error)
  }

  init(apiClient: OpenLibraryAPI) {
    self.apiClient = apiClient
  }

  @MainActor
  func loadSynopsis(from id: String) async {
    let endpoint: OpenLibraryEndpoint = OpenLibraryEndpoint.init(bookId: id)
    self.state = .loading
    do {
        self.synopsis = try await apiClient.fetchSynopsis(from: endpoint)
        self.state = .success(data: synopsis!)
    } catch {
      self.state = .failed(error: error)
    }
  }
}

