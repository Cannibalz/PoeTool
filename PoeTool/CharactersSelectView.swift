//
// Created by 高梵 on 2019/10/14.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
struct leaguePicker: View
{
    @ObservedObject var viewModel : CharacterSelectViewModel
    var body : some View
    {
        Picker(selection: $viewModel.leagueIndex, label: Text("League"))
        {
            ForEach(0..<viewModel.account.leagues.count)
            { index in
                Text(self.viewModel.account.leagues[index]).tag(index)
            }
        }.padding(.bottom, 30.0).pickerStyle(SegmentedPickerStyle())
    }
}
struct characterCell: View
{
    var characterInfo : CharacterInfo
    var body : some View
    {
//        NavigationLink(destination:CharacterDetailView())
//        {
            HStack
            {
                Image(characterInfo.className)
                    .resizable()
                    .frame(width: 106*1.3, height: 49*1.3)
                    
                VStack(alignment: .leading)
                {
                    Text(characterInfo.id).fontWeight(.medium)
                    Text(characterInfo.className).fontWeight(.light)
                    Text("\(characterInfo.level)").fontWeight(.light)
                    Text(characterInfo.league).fontWeight(.light)
                }
            }
//        }
    }
}

struct CharacterSelectView: View
{
    @State private var leagueIndex = 0
    @State private var selected : Int? = 0
    @ObservedObject var viewModel = CharacterSelectViewModel()
    var body : some View
    {
            VStack
            {
                NavigationLink(destination: CharacterDetailView(), tag: 1, selection: $selected){EmptyView()}
                List
                {
                    ForEach(viewModel.account.charaters)
                    {chara in
                        if self.viewModel.account.leagues[self.viewModel.leagueIndex] == "All"
                        {
                            characterCell(characterInfo: chara)
                            .gesture(TapGesture().onEnded
                            {dunnowtf in
                                self.selectCharacter(chara:chara)
                                self.selected = 1
                            })
                        }
                        else if chara.league == self.viewModel.account.leagues[self.viewModel.leagueIndex]
                        {
                            characterCell(characterInfo: chara)
                            .gesture(TapGesture().onEnded
                            {dunnowtf in
                                self.selectCharacter(chara:chara)
                                self.selected = 1
                            })
                        }
                    }
                }
                leaguePicker(viewModel: viewModel)
                }.navigationBarTitle(Text("Characters")).navigationBarBackButtonHidden(true)
        

    }
    func selectCharacter(chara:CharacterInfo)
    {
        PoEData.shared.account.selectedCharacter = chara
        print(chara.id)
    }
}
#if DEBUG
struct CharacterSelectView_Previews: PreviewProvider {
    
    static var previews: some View {
        CharacterSelectView()
    }
}
#endif
