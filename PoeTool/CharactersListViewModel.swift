//
// Created by 高梵 on 2019/10/17.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import SwiftUI
import Combine

class CharactersListViewModel : ObservableObject
{
    @Published var selectedLeague = String()
    @Published var leagueIndex = Int(0)
    @Published var charactersInfo : [CharacterInfo] = [CharacterInfo]()
    @Published var leagues : [String] = [String]()
    @Published var inThisView = false
    var selectedCharacter : CharacterInfo = CharacterInfo()
    init()
    {
        
    }
    init(isLogged:Bool)
    {
        print(PoEData.shared.account.Name)
        print(PoEData.shared.account.POESESSID)
        if isLogged && inThisView
        {
            print(leagues)
            PoEData.shared.createList
            {(characters,set) in
                self.charactersInfo = characters
                self.leagues = set
                print(set)
            }
        }
        
        print("is Logged ? :\(isLogged)")
    }
    deinit {
        
    }
}
