//
//  CharacterDetail.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/23.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct CharacterDetailView:View
{
    
    var character : CharacterInfo
    @ObservedObject var viewModel = CharacterDetailViewModel()
    var body: some View
    {
        VStack
        {
            Text(character.id)
            Text(character.className)
        }
    }
}

#if DEBUG
struct CharacterDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        CharacterDetailView(character: CharacterInfo(id: "Test", league: "Standard", className: "Engineer", level: 0))
    }
}
#endif
