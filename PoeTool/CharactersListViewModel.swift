//
// Created by 高梵 on 2019/10/17.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Combine
import SwiftUI

class CharactersListViewModel: ObservableObject
{
    @Published var selectedLeague = String()
    @Published var leagueIndex = Int(0)
    @Published var charactersInfo: [CharacterInfo] = [CharacterInfo]()
    @Published var leagues: [String] = [String]()
    @Published var created = false
    var selectedCharacter: CharacterInfo = CharacterInfo()
    init()
    {
    }

    init(isLogged: Bool)
    {
        print("is Logged ? :\(isLogged)")
    }

    deinit
    {
    }

    func viewOnApper()
    {
        if true //! created || !PoEData.shared.isLogged
        {
            PoEData.shared.createList
            { characters, set in
                self.charactersInfo = characters
                self.leagues = set
                print(set)
            }
            created = true
        }
    }
}
