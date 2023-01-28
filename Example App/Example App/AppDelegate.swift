// import Foundation
// import UIKit
// import CoreDataPlus
// import CoreData
// 
// class AppDelegate: NSObject, UIApplicationDelegate {
//     // let pc = PersistenceController.shared
//     // let _ = Persist.enable()
//     
//     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//         
//         // Persist.enable(modelName: "Example_App")
//         Persist.enable()
//         
//         // dump(Persist.shared.assignedModelName)
//         let viewContext = Persist.shared.viewContext//pc.container.viewContext//
//         // dump(Persist.shared.assignedModelName)
//         let backgroundContext = Persist.shared.backgroundContext
//         // let backgroundContext = pc.container.newBackgroundContext()// Persist.shared.backgroundContext
//         // backgroundContext.automaticallyMergesChangesFromParent = true
//         // backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
//         
//         CoreDataPlus.setup( viewContext: viewContext,
//                             backgroundContext: backgroundContext,
//                             logHandler: { message in print("🌎🌧 log: \(message)") }
//         )
//         
//         return true
//     }
// }
