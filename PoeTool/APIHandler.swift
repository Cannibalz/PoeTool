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
enum invID:String
{
    enum Equipments:String
    {
        case Helm = "Helm"
        case BodyArmour = "BodyArmour"
        case Weapon = "Weapon"
        case Weapon2 = "Weapon2"
        case Offhand = "Offhand"
        case Offhand2 = "Offhand2"
        case Ring = "Ring"
        case Ring2 = "Ring2"
        case Amulet = "Amulet"
        case Gloves = "Gloves"
        case Boots = "Boots"
        case Belt = "Belt"
    }
    case Flask = "Flask"
    case MainInventory = "MainInventory"
}

struct Account {
    var charaters : [CharacterInfo] = [CharacterInfo]()
    var Name : String = ""
    var leagues : [String] = [""]
    var POESESSID = ""
    var selectedCharacter : CharacterInfo = CharacterInfo(name: "Error", league: "Error", className: "Error", level: 0)
    var selectedCharasterItems = [Item]()
}
class PoEData : NSObject
{
    static let shared = PoEData()
    var isLogged : Bool = false
    var charaters : [CharacterInfo] = [CharacterInfo]()
    var account = Account()
    init(name:String,POESESSID:String)
    {
        self.account.Name = name
        self.account.POESESSID = POESESSID
    }
    var APIRequestCancellable: Cancellable?
    {
        didSet{oldValue?.cancel()}
    }
    private override init(){
    }
    func createList(Completion:@escaping ([CharacterInfo],[String])->())
    {
        let urlString = "https://www.pathofexile.com/character-window/get-characters?accountName=\(self.account.Name)"
        var characters = [CharacterInfo]()
        var set = [String]()
        getData(url: urlString, POESESSID: self.account.POESESSID)
        {
            Body in
            do
            {
                characters = try JSONDecoder().decode([CharacterInfo].self, from: Body.data)
                set = [String]()
                set.append("All")
                for char in characters
                {
                    set.append(char.league)
                }
                set = set.removingDuplicates()
                Completion(characters,set)
            }
            catch
            {
                print(error)
            }
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
                //self.establishAccount(characterData: Body.data,name:accName,POESESSID:POESESSID)
                self.isLogged = true
            }
            Completion(statusCode)
        }
    }
    func getCharactersItems(completion data:@escaping(Bool)->())
    {
        let characterName = self.account.selectedCharacter.id
        let accountName = self.account.Name
        let POESESSID = self.account.POESESSID
        let urlString = String( "https://www.pathofexile.com/character-window/get-items?accountName=\(accountName)&character=\(characterName)")
        getData(url: urlString, POESESSID: POESESSID)
        {Body in
            let data = Body.data
            var characterDetail : CharacterDetail
            //var characterWithItems : CharacterWithItems
            do
            {
                print(data)
                characterDetail = try JSONDecoder().decode(CharacterDetail.self, from: data)
//                characterWithItems = characterDetail.character as! CharacterWithItems
//                for item in characterDetail.items
//                {
//
//                }
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
