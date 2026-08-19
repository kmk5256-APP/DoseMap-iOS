import SwiftUI

@main
struct DoseMapApp: App {
    @StateObject private var progressManager = UserProgressManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(progressManager)
                .preferredColorScheme(.dark)
        }
    }
}
