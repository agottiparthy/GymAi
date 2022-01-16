//
//  GymAiApp.swift
//  GymAi WatchKit Extension
//
//  Created by Ani Gottiparthy on 1/16/22.
//

import SwiftUI

@main
struct GymAiApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
