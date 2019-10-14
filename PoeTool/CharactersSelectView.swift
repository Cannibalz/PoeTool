//
// Created by 高梵 on 2019/10/14.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI

struct CharacterSelectView: View
{
    @Binding var account : AccountInfo
    var body : some View
    {
        NavigationView
        {
            List(account.characters)
            { character in
                Text(character.league)
            }
        }
        .navigationBarTitle(Text(account.accountName))
    }
}
