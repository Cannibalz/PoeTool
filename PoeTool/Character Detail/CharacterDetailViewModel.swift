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
    @Published var Detail : CharacterInfo = CharacterInfo(id: "1", league: "456", className: "789", level: 10)
    init()
    {
        
    }
    init(Detail:CharacterInfo)
    {
        self.Detail = Detail
    }
}
