import Foundation
import CoreData



public class Persist {
    public static let shared = Persist()
    var dataStore: DataStore
    private init() {
        dataStore = DataStore.shared
        dataStore.persistHandle = self
    }
    
    public class func enable(container: NSPersistentContainer) {
        let persist = Persist.shared
        persist.dataStore = DataStore.shared
        persist.dataStore.overriddenPersistentContainer = container
    }
    
    public class func enable(modelName: String) {
        let persist = Persist.shared
        persist.dataStore = DataStore.shared
        persist.dataStore.modelName = modelName
    }
    
    public class func enable() {
        let persist = Persist.shared
        persist.dataStore = DataStore.shared
    }
    
    // Bundle.main.urls(forResourcesWithExtension: "plist", subdirectory: Bundle.main.urls(forResourcesWithExtension: "momd", subdirectory: nil)!.first!.relativePath)!.first!
    
    // NSDictionary(contentsOf: Bundle.main.urls(forResourcesWithExtension: "plist", subdirectory: Bundle.main.urls(forResourcesWithExtension: "momd", subdirectory: nil)!.first!.relativePath)!.first!, error: ()).object(forKey: "NSManagedObjectModel_CurrentVersionName")
    
    // public class func enable(modelName: String) {
    //     let persist = Persist.shared
    //     persist.dataStore = DataStore.shared
    //     persist.dataStore.modelName = modelName
    // }
    
    // NSManagedObjectModel(contentsOf: Bundle.main.urls(forResourcesWithExtension: "momd", subdirectory: nil)!.first!)!
    // TODO: need this?
    private class func enable2(modelName: String) -> Persist {
        let persist = Persist.shared
        persist.dataStore.modelName = modelName
        return persist
    }
}

public class DataStore {
    public static let shared = DataStore()
    // public static var names: String? = nil
    internal var modelName: String!
    internal var overriddenPersistentContainer: NSPersistentContainer?
    
    /// The core data model name. Will be nil if you used `Persist.enable(container:)`.
    public var assignedModelName: String? {
        modelName
    }
    // public static func useName(_ n: String) {
    //     DataStore.names = n
    // }
    var persistHandle: Persist?
    private func guessModelName() -> String? {
        let momdUrls = Bundle.main.urls(forResourcesWithExtension: "momd", subdirectory: nil) ?? []
        
        guard momdUrls.count == 1 else { return nil }
        
        return momdUrls.first?.lastPathComponent.replacingOccurrences(of: ".momd", with: "")
    }
    
    @available(*, deprecated, message: "Use guessModelName() instead")
    private func guessModelNameFromVersionInfoPlist() -> String? {
        let momdUrl = Bundle.main.urls(forResourcesWithExtension: "momd", subdirectory: nil)
        
        guard let momdPath = momdUrl?.first?.relativePath else { return nil }
        
        guard let versionInfoPlist = Bundle.main.url(forResource: "VersionInfo", withExtension: "plist", subdirectory: momdPath) else { return nil }
        
        guard let currentVersionName = try? NSDictionary(contentsOf: versionInfoPlist, error: ()).object(forKey: "NSManagedObjectModel_CurrentVersionName") as? String else { return nil }
        
        return currentVersionName
    }
    
    private init() {
        if let autoModelName = guessModelName() {
            modelName = autoModelName
        }
    }
    
    // internal init(container: NSPersistentContainer) {
    //     overriddenPersistentContainer = container
    // }
    // internal init(modelName: String) {
    //     self.modelName = modelName
    // }
    
    private static func sharedInstanceWith(modelName: String) -> DataStore {
        let instance = DataStore.shared
        instance.modelName = modelName
        return instance
    }
    
    lazy var undoManager: UndoManager = {
        let u = UndoManager()
        return u
    }()
    
    /// Read-only context for use on main thread.
    public lazy var viewContext: NSManagedObjectContext = {
        let c = persistentContainer.viewContext
        c.automaticallyMergesChangesFromParent = true
        return c
    }()
    
    /// Single background context for all writes, and background data loading.
    public lazy var backgroundContext: NSManagedObjectContext = {
        let newbackgroundContext = persistentContainer.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        newbackgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return newbackgroundContext
    }()
    
    // lazy var persistentContainer: NSPersistentCloudKitContainer = {
    //     let container = NSPersistentCloudKitContainer(name: "AmazingPodcasts5")
    //
    //     // if inMemory {
    //     //     container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    //     // }
    //
    //     // let iCloudSyncEnabled = UserDefaults.standard.bool(forKey: "Settings.iCloudEnabled")
    //
    //
    //     container.persistentStoreDescriptions.forEach({
    //         // disable cloudkit:
    //         // if !iCloudSyncEnabled {
    //         //     $0.cloudKitContainerOptions = nil
    //         // }
    //         // keep this:
    //         // This allows a 'non-iCloud' sycning container to keep track of changes if a user changes their mind
    //         // and turns it on.
    //         $0.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    //     })
    //
    //     container.loadPersistentStores(completionHandler: { (storeDescription, error) in
    //         if let error = error as NSError? {
    //             fatalError("Unresolved error \(error), \(error.userInfo)")
    //         }
    //
    //         // turn on remote change notifications
    //         let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
    //         storeDescription.setOption(true as NSNumber, forKey: remoteChangeKey)
    //
    //     })
    //
    //     container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    //     container.viewContext.automaticallyMergesChangesFromParent = true
    //
    //     return container
    // }()
    lazy var persistentContainer: NSPersistentContainer = {
        if let c = overriddenPersistentContainer {
            return c
        } else {
            return _persistentContainer
        }
    }()
    lazy var _persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    func initialSetup() {
        viewContext.perform {
            var needsSave = false
            
            if needsSave {
                self.save(context: self.viewContext)
            }
        }
    }
    
    /// Saves the `NSManagedObjectContext` to disk.
    func save(context: NSManagedObjectContext = DataStore.shared.viewContext) {
        try! context.save()
    }
}
