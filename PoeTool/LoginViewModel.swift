import SwiftUI
import Combine

final class LoginViewModel: ObservableObject
{
    @Published var accName = "niuwencong1"
    @Published var POESSID = "f2b5f9a200793c5b0f33ad660f8b31a8"
    @Published private(set) var accountInfo = AccountInfo()
    @Published private(set) var charactersInfo = [CharacterInfo]()
    private var loginCancellable: Cancellable?
    {
        didSet{oldValue?.cancel()}
    }
    
    func login()
    {
        let urlString = URL(string: "https://www.pathofexile.com/character-window/get-characters?accountName=\(accName)")
        let urlReq = URLRequest(url: urlString!)
        loginCancellable = URLSession.shared.dataTaskPublisher(for: urlReq)
            .map{$0.data}
            .decode(type: [CharacterInfo].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: \.charactersInfo, on: self)
    }
}
