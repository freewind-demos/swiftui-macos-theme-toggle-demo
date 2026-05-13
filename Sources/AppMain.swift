import SwiftUI

@main
struct ThemeToggleDemoApp: App {
    var body: some Scene {
        Window("Light / Dark Theme Toggle", id: "main") {
            ContentView()
        }
        .defaultSize(width: 720, height: 520)
        .windowStyle(.hiddenTitleBar)
    }
}
