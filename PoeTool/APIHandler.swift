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
enum inventoryID
{
    enum Equipments:String
    {
        case Helm = "Helm"
        case BodyArmour = "BodyArmour"
    }
}

struct Account {
    var charaters : [CharacterInfo] = [CharacterInfo]()
    var Name : String = ""
    var leagues : [String] = [""]
    var POESESSID = ""
    var selectedCharacter : CharacterInfo = CharacterInfo(id: "Error", league: "Error", className: "Error", level: 0)
    var selectedCharasterItems = [Item]()
}
class PoEData : NSObject
{
    static let shared = PoEData()
    var isLogged : Bool = false
    var charaters : [CharacterInfo] = [CharacterInfo]()
    var account = Account()
    var APIRequestCancellable: Cancellable?
    {
        didSet{oldValue?.cancel()}
    }
    private override init(){
    }
    func establishAccount(characterData:Data,name:String,POESESSID:String)
    {
        do
        {
            var chars = try JSONDecoder().decode([CharacterInfo].self, from: characterData)
            self.account.charaters = chars
            self.account.Name = name
            self.account.POESESSID = POESESSID
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
        let urlString = "https://www.pathofexile.com/character-window/get-characters?accountName=\(accName)"
        getData(url: urlString, POESESSID: POESESSID)
        {Body in
            let statusCode = (Body.response as! HTTPURLResponse).statusCode
            if statusCode == 200
            {
                self.establishAccount(characterData: Body.data,name:accName,POESESSID:POESESSID)
                self.isLogged = true
            }
            Completion(statusCode)
        }
    }
    func getCharactersItems(completion:@escaping(Bool)->())
    {
        let characterName = self.account.selectedCharacter.id
        let accountName = self.account.Name
        let POESESSID = self.account.POESESSID
        let urlString = String( "https://www.pathofexile.com/character-window/get-items?accountName=\(accountName)&character=\(characterName)")
        getData(url: urlString, POESESSID: POESESSID)
        {Body in
            let data = Body.data
            var characterDetail : CharacterDetail
            var characterWithItems : CharacterWithItems
            do
            {
                print(data)
                characterDetail = try JSONDecoder().decode(CharacterDetail.self, from: data)
                characterWithItems = characterDetail.character as! CharacterWithItems
                for item in characterDetail.items
                {
//                    if item.inventoryID ==
                }
                print(characterDetail.items)
            }
            catch
            {
                print("Error here:\(error)")
            }
        }
    }
    private func getData(url:String,POESESSID:String,completion:@escaping (URLSession.DataTaskPublisher.Output)->())
    {
        let url = URL(string: url)
        var urlReq = URLRequest(url: url!)
        urlReq.setValue("POESESSID=\(POESESSID)", forHTTPHeaderField: "cookie")
        APIRequestCancellable = URLSession.DataTaskPublisher(request: urlReq, session: .shared)
        .map{$0}
        .receive(on: RunLoop.main)
        .sink(receiveCompletion:
        {_ in},
        receiveValue:
        {body in
            completion(body)
        })
    }
}
