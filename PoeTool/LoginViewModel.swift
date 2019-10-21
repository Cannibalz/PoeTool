import SwiftUI
import Combine

class LoginViewModel: ObservableObject
{
    @Published var accName = "niuwencong1" //asdfasdfasdf : forbidden
    @Published var POESSID = "f2b5f9a200793c5b0f33ad660f8b31a8"
    @Published private(set) var charactersInfo = [CharacterInfo]()
    private var loginCancellable: Cancellable?
    {
        didSet{oldValue?.cancel()}
    }
    
    func login(completion:@escaping (AccountInfo)->())
    {
        let urlString = URL(string: "https://www.pathofexile.com/character-window/get-characters?accountName=\(accName)")
        var urlReq = URLRequest(url: urlString!)
        urlReq.setValue("POESESSID=\(POESSID)", forHTTPHeaderField: "cookie")
        
        loginCancellable = URLSession.DataTaskPublisher(request: urlReq, session: .shared)
            .map{$0.data}
            .decode(type: [CharacterInfo].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion:{ completion in
                switch completion
                {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            },receiveValue:
            {charas in
                var accInfo = AccountInfo()
                var leaguesArray = [String]()
                for var character in charas
                {
                    leaguesArray.append(character.league)
                }
                leaguesArray.append("All")
                accInfo.characters = charas
                accInfo.accountName = self.accName
                accInfo.leagues = leaguesArray.removingDuplicates()
                print(charas)
                return completion(accInfo)
            }
            )
            //.assign(to: \.charactersInfo, on: self)
    }
    func accountAuth()
    {
        
    }
}


