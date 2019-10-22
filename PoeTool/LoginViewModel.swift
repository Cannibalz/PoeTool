import SwiftUI
import Combine

class LoginViewModel: ObservableObject
{
    @Published var accName = ""//"niuwencong1"
    @Published var POESESSID = ""//"f2b5f9a200793c5b0f33ad660f8b31a8"
    @Published var wannaStore : Bool = false
    @Published var authed : Bool = false
    @Published var isLoading : Bool = false
    init()
    {
        if let accName: String = UserDefaults.standard.string(forKey: "accName"), let POESESSID: String = UserDefaults.standard.string(forKey: "POESESSID"), let wannaStore:Bool = UserDefaults.standard.bool(forKey: "wannaStore")
        {
            self.accName = accName
            self.POESESSID = POESESSID
            self.wannaStore = wannaStore
            self.accountAuth()
        }
    }
    func accountAuth()
    {
        isLoading = true
        PoEAPI().isValid(accName: self.accName, POESESSID: self.POESESSID, Completion:
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
            if let accName : String = self.accName, let POESSID : String = self.POESESSID
            {
                UserDefaults.standard.set(accName, forKey: "accName")
                UserDefaults.standard.set(POESSID, forKey: "POESESSID")
                UserDefaults.standard.set(true ,forKey:"wannaStore")
            }
        }
    }
}


