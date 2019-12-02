import SwiftUI
import Combine

class LoginViewModel: ObservableObject
{
    @Published var accName = "niuwencong1"
    @Published var POESESSID = "be96f2b25d7639acbf8a865240f2d9c5"
    @Published var wannaStore : Bool = false
    @Published var authed : Bool = false
    @Published var isLoading : Bool = false
//    var nextViewModel : CharactersListViewModel?
    var PoEinstance = PoEData.shared
    init()
    {
        
    }
    func viewOnApper()
    {
        if let accName: String = UserDefaults.standard.string(forKey: "accName"), let POESESSID: String = UserDefaults.standard.string(forKey: "POESESSID")
        {
            PoEData.shared.ValidByUserDefault()
            self.authed = true
            
        }
    }
    func accountAuth()
    {
        isLoading = true
        //PoEAPI.shared.Character.isValid(accName: self.accName, POESESSID: self.POESESSID, Completion:
        PoEinstance.isValid(accName: self.accName, POESESSID: self.POESESSID, Completion:
        {statusCode in
            
            if statusCode == 200
            {
                self.authed = true
                self.isLoading = false
                self.storeInfo()
            }
            self.isLoading = false
        })
    }
    func storeInfo()
    {
        if wannaStore
        {
            let accName : String = self.accName
            let POESSID : String = self.POESESSID
            UserDefaults.standard.set(accName, forKey: "accName")
            UserDefaults.standard.set(POESSID, forKey: "POESESSID")
            UserDefaults.standard.set(true ,forKey:"wannaStore")
            
        }
    }
}


