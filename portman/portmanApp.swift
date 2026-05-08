import SwiftUI

@main
struct portmanApp: App {
    var body: some Scene {
        MenuBarExtra {
            PortListView()
        } label: {
            Image(systemName: "point.3.connected.trianglepath.dotted")
        }
        .menuBarExtraStyle(.window)
    }
}
