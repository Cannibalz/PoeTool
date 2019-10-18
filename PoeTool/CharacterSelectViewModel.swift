//
// Created by 高梵 on 2019/10/17.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import SwiftUI
import Combine

class CharacterSelectViewModel : ObservableObject
{
    @Published var selectedLeague = String()
    @State var leagueIndex = Int(0)
    @Published var accountInfo : AccountInfo = AccountInfo.shared
//    init(accountInfo:AccountInfo) {
//        self.accountInfo = accountInfo
//    }
    init()
    {
        print(print(AccountInfo.shared.characters))
    }
    deinit {
        
    }
    func filter()
    {

    }

}
