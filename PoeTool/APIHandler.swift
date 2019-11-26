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
                self.isLogged = true
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
                self.account.Name = accName
                self.account.POESESSID = POESESSID
                //self.establishAccount(characterData: Body.data,name:accName,POESESSID:POESESSID)
                self.isLogged = true
            }
            Completion(statusCode)
            
        }
    }
    func ValidByUserDefault()
    {
        self.account.Name = UserDefaults.standard.string(forKey: "accName")!
        self.account.POESESSID = UserDefaults.standard.string(forKey: "POESESSID")!
    }
    func getCharactersItems(name:String,completion items:@escaping(CharacterDetail)->())
    {
        let characterName = name
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
                characterDetail = try JSONDecoder().decode(CharacterDetail.self, from: data)
                items(characterDetail)
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
    func cancel()
    {

        self.APIRequestCancellable?.cancel()
        print("Requset Cancelled")
    }
}

// Stashs
extension PoEData
{
    func stashInit(leagueName: String,completion: @escaping (Stash)->())
    {
        let urlString = "https://www.pathofexile.com/character-window/get-stash-items?league=\(leagueName)&realm=pc&accountName=\(account.Name)&tabs=1&tabIndex=2"
        getData(url: urlString, POESESSID: self.account.POESESSID)
        { Body in
            var data = Body.data
            var stringData : String = String(data: data, encoding: .utf8) ?? ""
            self.modifyLayoutsName(stringData: &stringData)
            data = stringData.data(using: .utf8)!
            var stashs : Stash
            do
            {
                stashs = try JSONDecoder().decode(Stash.self, from: data)
                completion(stashs)
            }
            catch
            {
                print("error in getStash: \(error)")
            }
        }
    }
    func modifyLayoutsName(stringData: inout String)
    {
        
        stringData = stringData.replacingOccurrences(of: "currencyLayout", with: "tabLayout")
        stringData = stringData.replacingOccurrences(of: "fragmentLayout", with: "tabLayout")
        stringData = stringData.replacingOccurrences(of: "essenceLayout", with: "tabLayout")
        stringData = stringData.replacingOccurrences(of: "delveLayout", with: "tabLayout")
    }
}
