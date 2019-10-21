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
    private var LoginCancellable: Cancellable?
    {
        didSet{oldValue?.cancel()}
    }
    func Authentication()
    {
        
    }
    func isValid(accName:String,POESESSID:String,Completion:@escaping(Int)->())
    {
        let urlString = URL(string: "https://www.pathofexile.com/character-window/get-characters?accountName=\(accName)")
        var urlReq = URLRequest(url: urlString!)
        var isError = true
        urlReq.setValue("POESESSID=\(POESESSID)", forHTTPHeaderField: "cookie")
        var login = LoginCancellable
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
