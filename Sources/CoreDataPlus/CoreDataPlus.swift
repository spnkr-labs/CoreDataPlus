
import Foundation
import CoreData
import NotificationCenter

public var DB: CoreDataPlus = CoreDataPlus.shared


public class CPD {
    public var viewContext: NSManagedObjectContext?
    public var backgroundContext: NSManagedObjectContext?
    
    init(container: NSPersistentContainer) {
        viewContext = container.viewContext
        backgroundContext = container.newBackgroundContext()
    }
    
    
}



extension NSPersistentContainer {
    
}

public class Calus {
    public static let shared = Calus()
    
    private init() { }
}

// why does it need to stick around forever?
// because
// 
// if the view context is bound only to views that use it, it's ok if that vanishes
//     
//     background context: must be none or 1. 1 must always be tied to all view contexts

public class Treasured {
    
}

// remove all shared?

public class CoreDataPlus {
    public static let version = "0.5.1"
    
    public static let shared = CoreDataPlus()
    internal static var config: Config?
    
    internal struct Config {
        var viewContext: NSManagedObjectContext
        var backgroundContext: NSManagedObjectContext? = nil
    }
    
    public var viewContext: NSManagedObjectContext {
        get {
            guard let config = CoreDataPlus.config else {
                raiseError(.noForeground)
                return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            }
            
            return config.viewContext
        }
    }
    
    public var backgroundContext: NSManagedObjectContext? {
        get { CoreDataPlus.config?.backgroundContext }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - viewContext: <#viewContext description#>
    ///   - backgroundContext: <#backgroundContext description#>
    ///   - logHandler: <#logHandler description#>
    ///
    /// Example
    /// ```swift
    ///    let viewContext = PersistenceController.shared.container.viewContext
    ///
    ///            let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
    ///            backgroundContext.automaticallyMergesChangesFromParent = true
    ///            backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    ///
    ///            CoreDataPlus.setup( viewContext: viewContext,
    ///                                backgroundContext: backgroundContext,
    ///                                    logHandler: { message in print("🌎🌧 log: \(message)") }
    ///            )
    ///    let viewContext = PersistenceController.shared.container.viewContext
    /// ```
    ///
    ///
    ///
    ///
    public class func setup(viewContext: NSManagedObjectContext,
                            backgroundContext: NSManagedObjectContext? = nil,
                            logHandler: @escaping (String) -> Void) {
        
        if CoreDataPlus.config != nil {
            CoreDataPlusLogger.shared.log("CoreDataPlus.setup has already been called. Ignoring.")
        }
        
        CoreDataPlusLogger.configure(logHandler: logHandler)
        CoreDataPlus.config = Config(viewContext: viewContext, backgroundContext: backgroundContext)
        
    }

    private init() {
        CoreDataPlusLogger.shared.log("Initializing CoreDataPlus.shared")
    }
}

