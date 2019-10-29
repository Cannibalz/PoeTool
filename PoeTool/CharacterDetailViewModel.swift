//
//  CharacterDetailViewModel.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/23.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import SwiftUI
class CharacterDetailViewModel : ObservableObject
{
    @Published var selectCharacter:CharacterInfo
    @Published var items:[Item] = [Item]()
    init()
    {
        self.selectCharacter = PoEData.shared.account.selectedCharacter
        PoEData.shared.getCharactersItems()
        {_ in
            self.items = PoEData.shared.account.selectedCharasterItems
        }
    }
    
}
