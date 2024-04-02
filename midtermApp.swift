import SwiftUI

@main
struct midtermApp: App {

    var body: some Scene {
        WindowGroup {
            TabContainer()
                .modelContainer(for: Book.self)
        }
    }
}

