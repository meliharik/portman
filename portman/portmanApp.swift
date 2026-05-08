import SwiftUI

@main
struct portmanApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false

    var body: some Scene {
        MenuBarExtra {
            PortListView()
        } label: {
            Image(systemName: "point.3.connected.trianglepath.dotted")
        }
        .menuBarExtraStyle(.window)

        Window("Welcome to portman", id: "welcome") {
            WelcomeView()
                .onAppear {
                    NSApp.setActivationPolicy(.regular)
                    NSApp.activate(ignoringOtherApps: true)
                }
                .onDisappear {
                    NSApp.setActivationPolicy(.accessory)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultPosition(.center)
        .defaultLaunchBehavior(hasSeenWelcome ? .suppressed : .presented)
        .restorationBehavior(.disabled)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        let seen = UserDefaults.standard.bool(forKey: "hasSeenWelcome")
        NSApp.setActivationPolicy(seen ? .accessory : .regular)
    }
}
