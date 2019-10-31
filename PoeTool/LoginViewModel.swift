import SwiftUI
import Combine

class LoginViewModel: ObservableObject
{
    @Published var accName = ""
    @Published var POESESSID = ""
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
            let wannaStore:Bool = UserDefaults.standard.bool(forKey: "wannaStore")
            self.accName = accName
            self.POESESSID = POESESSID
            self.wannaStore = wannaStore
            if !PoEinstance.isLogged
            {
                self.accountAuth()
            }
            
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


