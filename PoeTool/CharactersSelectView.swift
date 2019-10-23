//
// Created by 高梵 on 2019/10/14.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
struct characterList: View
{
    var body : some View
    {
        Text("test")
    }
}
struct leaguePicker: View
{
    @ObservedObject var viewModel : CharacterSelectViewModel
    @State private var leagueIndex = 0
    var body: some View
    {
        Section
        {
            Picker(selection: $viewModel.leagueIndex, label: Text("League"))
            {
                ForEach(0..<viewModel.account.leagues.count)
                {
                    Text(self.viewModel.account.leagues[$0]).tag($0)
                }
            }
        }.foregroundColor(.blue)
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
    @State private var leagueIndex = 0
    @ObservedObject var viewModel = CharacterSelectViewModel()
    var body : some View
    {
        NavigationView
        {
            VStack
            {
                Form
                {
                    leaguePicker(viewModel: self.viewModel)
                    //characterList(accountInfo: account)
                    List(viewModel.account.charaters)
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
    
    static var previews: some View {
        CharacterSelectView()
    }
}
#endif
