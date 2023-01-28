//
//  Example_AppApp.swift
//  Example App
//
//  Created by Will Jessop on 10/26/22.
//

// import SwiftUI
// import CoreDataPlus
//
// @main
// struct Example_AppApp: App {
//     let persistenceController = PersistenceController.shared
//     // let dataStore = Persist.enable()
//
//     @Environment(\.scenePhase) private var phase
//     @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//
//     var body: some Scene {
//         WindowGroup {
//             ContentView()
//                 .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                 .onAppear {
//
//                 }
//         }
//         .onChange(of: phase) { newPhase in
//             switch newPhase {
//             case .background:
//                 try! persistenceController.container.viewContext.save()
//             default:
//                 break
//             }
//         }
//     }
//
// }

import SwiftUI
import CoreData
import CoreDataPlus


@main
struct Example_AppApp: App {
    // let persistenceController = PersistenceController.shared
    // let dataStore =

    init() {
        let p = Persist.enable()
        // Persist.e
        // dump(Persist.shared.assignedModelName)
        // Persist.setup(.automatic)
        // Persist.setup(viewContext: foo)
        // Persist.setup(viewContext: foo, backgroundContext: bar)
        // Persist.setup()
        
        CoreDataPlus.setup(viewContext: p.viewContext, backgroundContext: p.backgroundContext, logHandler: { _ in })
    }
    @Environment(\.scenePhase) private var phase
    // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, Persist.shared.viewContext)
                .onAppear {
                    // dump(Persist.shared.assignedModelName)
                }
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .background:
                try! Persist.shared.viewContext.save()
            default:
                break
            }
        }
    }

}

