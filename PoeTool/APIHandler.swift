//
//  APIHandler.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/21.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import CoreFoundation
import CoreGraphics
import Foundation
enum invID: String
{
    enum Equipments: String
    {
        case Helm
        case BodyArmour
        case Weapon
        case Weapon2
        case Offhand
        case Offhand2
        case Ring
        case Ring2
        case Amulet
        case Gloves
        case Boots
        case Belt
    }

    case Flask
    case MainInventory
}

struct Account
{
    var charaters: [CharacterInfo] = [CharacterInfo]()
    var Name: String = ""
    var leagues: [String] = [""]
    var POESESSID = ""
    var selectedCharacter: CharacterInfo = CharacterInfo(name: "Error", league: "Error", className: "Error", level: 0)
    var selectedCharasterItems = [Item]()
}

class PoEData: NSObject
{
    static let shared = PoEData()

    var isLogged: Bool = false

    var account = Account()
    init(name: String, POESESSID: String)
    {
        account.Name = name
        account.POESESSID = POESESSID
    }

    var APIRequestCancellable: Cancellable?
    {
        didSet { oldValue?.cancel() }
    }

    private override init()
    {
    }

    func createList(Completion: @escaping ([CharacterInfo], [String]) -> Void)
    {
        let urlString = "https://www.pathofexile.com/character-window/get-characters?accountName=\(account.Name)"
        var characters = [CharacterInfo]()
        var set = [String]()
        getData(url: urlString, POESESSID: account.POESESSID)
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
                Completion(characters, set)
            }
            catch
            {
                print(error)
            }
        }
    }

    func isValid(accName: String, POESESSID: String, Completion: @escaping (Int) -> Void)
    {
        let urlString = "https://www.pathofexile.com/character-window/get-stash-items?league=standard&realm=pc&accountName=\(accName)&tabs=0&tabIndex=0"
        getData(url: urlString, POESESSID: POESESSID)
        { Body in
            let statusCode = (Body.response as! HTTPURLResponse).statusCode
            if statusCode == 200
            {
                self.account.Name = accName
                self.account.POESESSID = POESESSID
                // self.establishAccount(characterData: Body.data,name:accName,POESESSID:POESESSID)
                self.isLogged = true
            }
            Completion(statusCode)
        }
    }

    func ValidByUserDefault()
    {
        account.Name = UserDefaults.standard.string(forKey: "accName")!
        account.POESESSID = UserDefaults.standard.string(forKey: "POESESSID")!
    }

    func getCharactersItems(name: String, completion items: @escaping (CharacterDetail) -> Void)
    {
        let characterName = name
        let accountName = account.Name
        let POESESSID = account.POESESSID
        let urlString = String("https://www.pathofexile.com/character-window/get-items?accountName=\(accountName)&character=\(characterName)")
        getData(url: urlString, POESESSID: POESESSID)
        { Body in
            let data = Body.data
            var characterDetail: CharacterDetail
            // var characterWithItems : CharacterWithItems
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

    private func getData(url: String, POESESSID: String, completion: @escaping (URLSession.DataTaskPublisher.Output) -> Void)
    {
        let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? "")
        var urlReq = URLRequest(url: url!)
        urlReq.setValue("POESESSID=\(POESESSID)", forHTTPHeaderField: "cookie")
        APIRequestCancellable = URLSession.DataTaskPublisher(request: urlReq, session: .shared)
            .map { $0 }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion:
                { status in
                    switch status
                    {
                    case let .failure(error):
                        print(error.localizedDescription)
                    case .finished:
                        break
                    }
                },
                receiveValue:
                { body in
                    completion(body)
            })
    }

    func cancel()
    {
        APIRequestCancellable?.cancel()
        print("Requset Cancelled")
    }

    func initAccount()
    {
        account = Account()
        isLogged = false
    }

    func allPrice(Completion: @escaping ([Line]) -> Void)
    {
        let priceableName: [String] = ["Currency", "Fragment", "Fossil", "Essence", "DivinationCard", "Incubator", "Oil", "Scarab", "Fossil", "Resonator", "Prophecy"]
        APIRequestCancellable = priceableName.publisher

            .map { $0 }
            .tryMap { Value in Value }
            .flatMap
        { type in
            self.typePrice(type: type)
        }
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { _ in

        })
        { wtf in
            // self.LineArray.append(contentsOf: wtf.lines)
            Completion(wtf.lines)
        }
    }

    func typePrice(type: String) -> AnyPublisher<Price, Error>
    {
        var apiType = "item"
        if type == "Fragment"
        {
            apiType = "currency"
        }
        let url = URL(string: "https://poe.ninja/api/data/\(apiType)overview?league=Metamorph&type=\(type)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: Price.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

// Stashs
extension PoEData
{
    func getStash(leagueName: String, tabIndex: Int, needTabsInfo: Int, completion: @escaping (parserStash) -> Void)
    {
        let urlString = "https://www.pathofexile.com/character-window/get-stash-items?league=\(leagueName)&realm=pc&accountName=\(account.Name)&tabs=\(needTabsInfo)&tabIndex=\(tabIndex)"
        getData(url: urlString, POESESSID: account.POESESSID)
        { Body in
            var data = Body.data
            var stringData: String = String(data: data, encoding: .utf8) ?? ""
            self.modifyLayoutsName(stringData: &stringData)
            data = stringData.data(using: .utf8)!
            var stashs: parserStash
            do
            {
                stashs = try JSONDecoder().decode(parserStash.self, from: data)
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
