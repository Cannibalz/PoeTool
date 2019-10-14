//
// Created by 高梵 on 2019/10/14.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI

struct characterCell: View
{
    var characterInfo : CharacterInfo
    var body : some View
    {
        VStack(alignment: .leading)
        {
            Text(characterInfo.id)
                .fontWeight(.heavy)
            Text(characterInfo.className)
            Text("\(characterInfo.level)")
            Text(characterInfo.league)
        }
    }
}

struct CharacterSelectView: View
{
    @Binding var account : AccountInfo
    var body : some View
    {
        NavigationView
        {
            List(account.characters)
            { chara in
                characterCell(characterInfo: chara)
            }
        }
        .navigationBarTitle(Text(account.accountName))
    }
}
