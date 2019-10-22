import SwiftUI
import Combine

class LoginViewModel: ObservableObject
{
    var accName = "niuwencong1"
    var POESSID = "f2b5f9a200793c5b0f33ad660f8b31a8"
    var statusCode : Int? = 0
    var isToggle : Bool = false
    var authed : Bool = false
    func accountAuth(accName:String, POESESSID:String,Completion:@escaping(Int)->())
    {
        PoEAPI().isValid(accName: accName, POESESSID: POESESSID, Completion:
        {statusCode in
            self.statusCode = statusCode
            Completion(statusCode)
        })
    }
    
}


