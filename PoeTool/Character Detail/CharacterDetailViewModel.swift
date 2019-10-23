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
    init()
    {
        self.selectCharacter = PoEData.shared.account.selectedCharacter
    }
    func test()
    {
        print(selectCharacter)
    }
}
