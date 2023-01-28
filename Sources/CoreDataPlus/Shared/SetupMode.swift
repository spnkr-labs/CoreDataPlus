import CoreData

public enum SetupMode {
    case automatic
    case withModelName(String)
    case withPersistentContainer(NSPersistentContainer)
    case with(viewContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext)
    case none
}
