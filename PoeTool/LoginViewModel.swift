import SwiftUI
import Combine

class LoginViewModel: ObservableObject
{
    @Published var statusCode : Int = 0
    
    func accountAuth(accName:String, POESESSID:String)
    {
        PoEAPI().isValid(accName: accName, POESESSID: POESESSID, Completion:
        {statusCode in
            self.statusCode = statusCode
        })
    }
}


