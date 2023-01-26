//
//  Example_AppApp.swift
//  Example App
//
//  Created by Will Jessop on 10/26/22.
//

import SwiftUI
import CoreDataPlus

@main
struct Example_AppApp: App {
    // let persistenceController = PersistenceController.shared
    let dataStore = DataStore.shared
    
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataStore.viewContext)
                .onAppear {
                    dump(DataStore.shared.assignedModelName)
                }
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .background:
                try! dataStore.viewContext.save()
            default:
                break
            }
        }
    }
    
}
