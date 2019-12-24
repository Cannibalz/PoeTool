//
//  CoreData.swift
//  PoeTool
//
//  Created by 高梵 on 2019/12/23.
//  Copyright © 2019 KaFn. All rights reserved.
//

import CoreData
import Foundation

//final class UserAcc: NSManagedObject
//{
//    @NSManaged var name: String
//    @NSManaged var poesessid: String
//}

class CoreData
{
    static let shared = CoreData()
    private lazy var persistentContainer: NSPersistentContainer =
    {
        let container = NSPersistentContainer(name: "PoeTool")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let nserror = error as NSError? {
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        })
        return container
    }()
    
    public var context : NSManagedObjectContext
    {
        get
        {
            return self.persistentContainer.viewContext
        }
    }
    
    public func save()
    {
        if self.context.hasChanges
        {
            do
            {
                try self.context.save()
                print("In CoreData shared save()")
            }
            catch
            {
                let nserror = error as NSError
                print(nserror)
            }
        }
    }
    
    class func executeBlockAndCommit(_ block: @escaping ()->Void)
    {
        block()
        CoreData.shared.save()
    }
}
