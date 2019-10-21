import SwiftUI
import Combine

class LoginViewModel: ObservableObject
{
    var isError = false
    func login(accName:String, POESESSID:String)->URLSession.DataTaskPublisher
    {
        var login = PoEAPI().Login(accName: accName, POESSID: POESESSID)
        return login as! URLSession.DataTaskPublisher

    }
    func accountAuth()
    {
        
    }
}


