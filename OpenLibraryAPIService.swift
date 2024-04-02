import CoreLocation
protocol OpenLibraryAPI {
  func fetchSynopsis(from endpoint: OpenLibraryEndpoint) async throws -> String
}

struct OpenLibraryAPIClient: OpenLibraryAPI, APIClient {
  let session: URLSession = .shared

  func fetchSynopsis(from endpoint: OpenLibraryEndpoint) async throws -> String {
    let path = endpoint.url
//     dump(path) // Uncomment to print out path
      let response: OpenLibraryResponse = try await performRequest(url: path!.absoluteString)
      return response.responseContainer.synopsis
  }
}
