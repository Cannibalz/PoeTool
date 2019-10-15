//
// Created by 高梵 on 2019/10/14.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
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
    @State private var leagueIndex = 0
    var body : some View
    {
        NavigationView
        {
            VStack
            {
                Form
                {
                    Section
                    {
                        Picker(selection: $leagueIndex, label: Text("League"))
                        {
                            ForEach(0..<account.leagues.count)
                            {
                                Text(self.account.leagues[$0]).tag($0)
                            }
                        }
                    }
                    .foregroundColor(.blue)
                    List(account.characters)
                    { chara in
                        NavigationLink(destination:Text("text"))
                        {
                            characterCell(characterInfo: chara)

                        }
                    }
                }
                //                .frame(height: 50.0) enable this if list separate from form
            }
        }
        .padding(.top, -10.0)
//        .navigationBarTitle(Text(account.accountName), displayMode: .automatic)
        
    }
}
#if DEBUG
struct CharacterSelectView_Previews: PreviewProvider {
@State static var accountInfo = AccountInfo(characters: [CharacterInfo(id: "", league: "", className: "", level: 0)], accountName: "niuwencong1", leagues: ["fds","aaa"])
    static var previews: some View {
        CharacterSelectView(account: $accountInfo)
    }
}
#endif
