import SwiftUI
import Combine

class LoginViewModel: ObservableObject
{
    @Published var accName = "niuwencong1"
    @Published var POESSID = "f2b5f9a200793c5b0f33ad660f8b31a8"
    @Published var isToggle : Bool = false
    @Published var authed : Bool = false
    
    func accountAuth(accName:String, POESESSID:String)
    {
        PoEAPI().isValid(accName: accName, POESESSID: POESESSID, Completion:
        {statusCode in
            var int : Int = statusCode
            if int == 200
            {
                self.authed = true
                print(self.authed)
            }
        })
    }
    
}


