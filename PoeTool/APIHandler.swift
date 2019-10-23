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
    func establishAccount(characterData:Data,name:String)
    {
        do
        {
            var chars = try JSONDecoder().decode([CharacterInfo].self, from: characterData)
            self.account.charaters = chars
            self.account.Name = name
            var set = [String]()
            set.append("All")
            for char in chars
            {
                set.append(char.league)
            }
            self.account.leagues = set.removingDuplicates()
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
                    self.establishAccount(characterData: res.data,name:accName)
                    
                }
                Completion(statusCode)
            })
    }
}
