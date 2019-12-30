import Combine
import SwiftUI

class LoginViewModel: ObservableObject
{
    @Published var accName = ""
    @Published var POESESSID = ""
    @Published var wannaStore: Bool = true
    @Published var authed: Bool = false
    @Published var isLoading: Bool = false
    @ObservedObject var dataSource = CoreDataDataSource<UserAcc>()
//    var nextViewModel : CharactersListViewModel?
    var PoEinstance = PoEData.shared
    init()
    {
        dataSource.loadDataSource()
        for userAcc in dataSource.fetchedObjects
        {
            print("-------")
            print(userAcc.name)
            print(userAcc.poesessid)
            print(userAcc.order)
            print("-------")
        }
        DuplicationRemove()
        print("DR")
    }

    func viewOnApper() -> Bool
    {
        if let _: Bool = UserDefaults.standard.bool(forKey: "wannaStore")
        {
            print(wannaStore)

            if let _: String = UserDefaults.standard.string(forKey: "accName"), let _: String = UserDefaults.standard.string(forKey: "POESESSID"), wannaStore
            {
                PoEData.shared.ValidByUserDefault()
                authed = true
            }
            return authed
        }
    }

    func accountAuth(completion: @escaping (Bool) -> Void)
    {
        var loginSuccess = false
        isLoading = true
        // PoEAPI.shared.Character.isValid(accName: self.accName, POESESSID: self.POESESSID, Completion:
        PoEinstance.isValid(accName: accName, POESESSID: POESESSID, Completion:
            { statusCode in

                if statusCode == 200
                {
                    self.authed = true
                    self.isLoading = false
                    loginSuccess = true
                    self.storeInfo()
                    completion(loginSuccess)
                }
                else
                {
                    completion(loginSuccess)
                }
                self.isLoading = false

        })
    }

    func storeInfo()
    {
        if wannaStore
        {
            var accArray = dataSource.fetchedObjects
            var isExisted = false
            for acc in accArray
            {
                if acc.name == self.accName
                {
                    acc.update(name: self.accName, poesessid: self.POESESSID, order: Int(acc.order))
                    isExisted = true
                    break
                }
            }
            if !isExisted
            {
                _ = UserAcc.createUserAcc(name: self.accName, poesessid: POESESSID, order: UserAcc.nextOrder())
            }
            

            
            let accName: String = self.accName
            let POESSID: String = POESESSID
            UserDefaults.standard.set(accName, forKey: "accName")
            UserDefaults.standard.set(POESSID, forKey: "POESESSID")
            UserDefaults.standard.set(true, forKey: "wannaStore")
        }
        else
        {
            print("unstored")
            UserDefaults.standard.set(false, forKey: "wannaStore")
        }
    }

    func DuplicationRemove()
    {
        print(dataSource.fetchedObjects.count)
        var accName: [String] = []
        CoreData.executeBlockAndCommit
        {
            for obj in self.dataSource.fetchedObjects
            {
                if !accName.contains(obj.name)
                {
                    accName.append(obj.name)
                }
                else
                {
                    obj.delete()
                }
            }
        }
        print(dataSource.fetchedObjects.count)
    }
}
