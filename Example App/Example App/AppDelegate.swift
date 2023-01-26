import Foundation
import UIKit
import CoreDataPlus
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Persist.enable(modelName: "Example_App")
        Persist.enable()
        
        dump(DataStore.shared.assignedModelName)
        let viewContext = DataStore.shared.viewContext
        dump(DataStore.shared.assignedModelName)
        
        let backgroundContext = DataStore.shared.backgroundContext
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        CoreDataPlus.setup( viewContext: viewContext,
                            backgroundContext: backgroundContext,
                            logHandler: { message in print("🌎🌧 log: \(message)") }
        )
        
        return true
    }
}
