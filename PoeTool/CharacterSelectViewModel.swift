//
// Created by 高梵 on 2019/10/17.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import SwiftUI
import Combine

class CharacterSelectViewModel : ObservableObject
{
    @Published var selectedLeague = String()
    @Published var leagueIndex = Int(2)
    @Published var account : Account
    //@Published var showingCharacters : [CharacterInfo]
    init()
    {
        self.account = PoEData.shared.account
    }
    deinit {
        
    }
    func filter()
    {

    }

}
