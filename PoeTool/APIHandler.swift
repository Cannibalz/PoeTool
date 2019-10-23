//
//  APIHandler.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/21.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import Combine
import CoreFoundation
import CoreGraphics
struct Account {
    var charaters : [CharacterInfo] = [CharacterInfo]()
    var Name : String = ""
    var leagues : [String] = [""]
}
class PoEData : NSObject
{
    static let shared = PoEData()
    var charaters : [CharacterInfo] = [CharacterInfo]()
    var account = Account()
    private override init(){
    }
    func decodeCharacter(characterData:Data)
    {
        do
        {
            self.account.charaters = try JSONDecoder().decode([CharacterInfo].self, from: characterData)
        }
        catch
        {
            print(error)
        }
    }
    func isValid(accName:String,POESESSID:String,Completion:@escaping(Int)->())
    {
        var characterCancellable: Cancellable?
        {
            didSet{oldValue?.cancel()}
        }
        let urlString = URL(string: "https://www.pathofexile.com/character-window/get-characters?accountName=\(accName)")
        var urlReq = URLRequest(url: urlString!)
        urlReq.setValue("POESESSID=\(POESESSID)", forHTTPHeaderField: "cookie")
        var login = characterCancellable
        login = URLSession.DataTaskPublisher(request: urlReq, session: .shared)
            .map{$0}
//            .decode(type: [CharacterInfo].self, decoder: JSONDecoder())
//            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink(receiveCompletion:
            {completion in},
            receiveValue:
            {res in
                let statusCode = (res.response as! HTTPURLResponse).statusCode
                if statusCode == 200
                {
                    do
                    {
                        
                        self.charaters = try JSONDecoder().decode([CharacterInfo].self, from: res.data)
                        print(self.charaters)
                    }
                    catch
                    {
                        print(error)
                    }
                    
                }
                Completion(statusCode)
            })
    }
}
