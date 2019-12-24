//
//  UserAcc+CoreData.swift
//  PoeTool
//
//  Created by 高梵 on 2019/12/24.
//  Copyright © 2019 KaFn. All rights reserved.
//

import CoreData
import Foundation

@objc(UserAcc)
public class UserAcc: NSManagedObject, Identifiable
{
    class func count() -> Int
    {
        let fetchRequest: NSFetchRequest<UserAcc> = UserAcc.fetchRequest()

        do
        {
            let count = try CoreData.shared.context.count(for: fetchRequest)
            return count
        }
        catch let error as NSError
        {
            print(error)
            return 0
        }
    }

    class func nextOrder() -> Int
    {
        let keyPathExpression = NSExpression(forKeyPath: "order")
        let maxNumberExpression = NSExpression(forFunction: "max:", arguments: [keyPathExpression])

        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "maxNumber"
        expressionDescription.expression = maxNumberExpression
        expressionDescription.expressionResultType = .decimalAttributeType

        var expressionDescriptions = [AnyObject]()
        expressionDescriptions.append(expressionDescription)

        // Build out our fetch request the usual way
        let request: NSFetchRequest<NSFetchRequestResult> = UserAcc.fetchRequest()
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = expressionDescriptions
        request.predicate = nil

        // Our result should to be an array of dictionaries.
        var results: [[String: AnyObject]]?

        do
        {
            results = try CoreData.shared.context.fetch(request) as? [[String: NSNumber]]

            if let maxNumber = results?.first!["maxNumber"]
            {
                // Return one more than the current max order
                return maxNumber.intValue + 1
            }
            else
            {
                // If no items present, return 0
                return 0
            }
        }
        catch _
        {
            // If any failure, just return default
            return 0
        }
    }
    class func allInOrder()->[UserAcc]
    {
        let dataSource = CoreDataDataSource<UserAcc>()
        return dataSource.fetch()
    }
    
    class func newUserAcc()->UserAcc
    {
        return UserAcc(context: CoreData.shared.context)
    }
    class func createUserAcc(name:String, poesessid:String, order:Int?) -> UserAcc
    {
        let userAcc = UserAcc.newUserAcc()
        userAcc.name = name
        userAcc.poesessid = poesessid
        userAcc.order = Int32(order ?? 0)
        CoreData.shared.save()
        
        return userAcc
    }
    public func update(name:String, poesessid:String, order:Int)
    {
        self.name = name
        self.poesessid = poesessid
        self.order = Int32(order)
        CoreData.shared.save()
    }
    public func delete()
    {
        CoreData.shared.context.delete(self)
    }
}

extension UserAcc
{
    @NSManaged public var name: String
    @NSManaged public var poesessid: String
    @NSManaged public var order: Int32
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAcc>
    {
        return NSFetchRequest<UserAcc>(entityName: "UserAcc")
    }
}
