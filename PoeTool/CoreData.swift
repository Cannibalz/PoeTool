//
//  CoreData.swift
//  PoeTool
//
//  Created by 高梵 on 2019/12/23.
//  Copyright © 2019 KaFn. All rights reserved.
//

import CoreData
import Foundation

final class UserAcc: NSManagedObject
{
    @NSManaged var name: String
    @NSManaged var poesessid: String
}

class CoreData
{
    static let shared = CoreData()
    var persistentContainer: NSPersistentContainer!

    class func createDataModel(completion: @escaping () -> Void)
    {
        let container = NSPersistentContainer(name: "PoeTool")
        container.loadPersistentStores
        { (_ , err) in
            guard err == nil else {fatalError("Failed to load store : \(err)") }
            DispatchQueue.main.async {
                self.shared.persistentContainer = container
                completion()
            }
        }
    }
}
