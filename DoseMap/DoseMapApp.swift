import SwiftUI

@main
struct DoseMapApp: App {
    @StateObject private var progressManager = UserProgressManager()
    
    var body: some Scene {
        WindowGroup {
#if DEBUG
            if let screen = DebugHarness.requestedScreen {
                DebugHarnessView(screen: screen)
                    .preferredColorScheme(.dark)
            } else {
                ContentView()
                    .environmentObject(progressManager)
                    .preferredColorScheme(.dark)
            }
#else
            ContentView()
                .environmentObject(progressManager)
                .preferredColorScheme(.dark)
#endif
        }
    }
}
