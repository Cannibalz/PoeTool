//
// Created by 高梵 on 2019/10/14.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
class LeaguePicker
{
    var leaguesSet : Set<String> = Set<String>()
    var leaguesArray : [String] = [String]()
    init()
    {

    }
    init(accountInfo:AccountInfo)
    {
        for var character in accountInfo.characters
        {
            leaguesArray.append(character.league)
        }
        self.leaguesSet = Set(leaguesArray.map{ $0 })
        print(leaguesSet)
    }

}
struct characterCell: View
{
    var characterInfo : CharacterInfo
    var body : some View
    {
        HStack
        {
            Image(characterInfo.className)
                .resizable()
                .frame(width: 106*1.3, height: 49*1.3)
                
            VStack(alignment: .leading)
            {
                Text(characterInfo.id).fontWeight(.heavy)
                Text(characterInfo.className).fontWeight(.light)
                Text("\(characterInfo.level)").fontWeight(.light)
                Text(characterInfo.league).fontWeight(.light)
            }
        }
    }
}

struct CharacterSelectView: View
{
    @Binding var account : AccountInfo
    var leaguePicker = LeaguePicker()
    var body : some View
    {
        NavigationView
        {
            List(account.characters)
            { chara in
                NavigationLink(destination:Text("text"))
                {
                    characterCell(characterInfo: chara)
                    
                }
            }
        }
        .navigationBarTitle(Text(account.accountName))
    }
}
