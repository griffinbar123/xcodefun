//
//  mscApp.swift
//  msc
//
//  Created by Griffin Barnard on 12/12/22.
//

import SwiftUI
import Firebase

@main
struct mscApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
