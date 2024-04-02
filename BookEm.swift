import SwiftUI

@main
struct BookEm: App {

    var body: some Scene {
        WindowGroup {
            TabContainer()
                .modelContainer(for: Book.self)
        }
    }
}

