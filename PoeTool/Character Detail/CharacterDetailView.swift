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
    @ObservedObject var viewModel = CharacterDetailViewModel()
    //@ObservedObject var viewModel = CharacterDetailViewModel(Detail:character)
    var body: some View
    {
        VStack
        {
            Text(viewModel.selectCharacter.className)
        }
    }
}

#if DEBUG
struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView()
    }
}
#endif
