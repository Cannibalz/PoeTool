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
    @Published var inThisView = true
    var selectedCharacter : CharacterInfo = CharacterInfo()
    init()
    {
        
    }
    init(isLogged:Bool)
    {
        
        
        print("is Logged ? :\(isLogged)")
    }
    deinit {
        
    }
    func viewOnApper()
    {
        print(PoEData.shared.account.Name)
        print(PoEData.shared.account.POESESSID)
        
        self.inThisView = false
        print(inThisView)
        PoEData.shared.createList
        {(characters,set) in
            self.charactersInfo = characters
            self.leagues = set
            print(set)
    
        }
    }
}
