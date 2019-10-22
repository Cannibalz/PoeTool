//
//  APIHandler.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/21.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import Combine
class PoEAPI
{
    static let shared = PoEAPI()
    func fetchCharacterData()
    {
        
    }
    
    var characterCancellable: Cancellable?
    {
        didSet{oldValue?.cancel()}
    }
    func isValid(accName:String,POESESSID:String,Completion:@escaping(Int)->())
    {
        
        let urlString = URL(string: "https://www.pathofexile.com/character-window/get-characters?accountName=\(accName)")
        var urlReq = URLRequest(url: urlString!)
        urlReq.setValue("POESESSID=\(POESESSID)", forHTTPHeaderField: "cookie")
        var login = characterCancellable
        login = URLSession.DataTaskPublisher(request: urlReq, session: .shared)
            .map{$0.response}
//            .decode(type: [CharacterInfo].self, decoder: JSONDecoder())
//            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink(receiveCompletion:
            {completion in
                print(completion)
            }, receiveValue:
            {res in
                let statusCode = (res as! HTTPURLResponse).statusCode
                Completion(statusCode)
            })
    }
    
    
}
