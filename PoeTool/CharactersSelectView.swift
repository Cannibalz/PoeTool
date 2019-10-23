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
//        Button(action: {self.selectCharacter()}) {
        NavigationLink(destination:CharacterDetailView())
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
//        }
    }
    func selectCharacter()
    {
        PoEData.shared.account.selectedCharacter = characterInfo
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
                List
                {
                    ForEach(viewModel.account.charaters)
                    {chara in
                        if self.viewModel.account.leagues[self.viewModel.leagueIndex] == "All"
                        {
                                characterCell(characterInfo: chara)
                        }
                        else if chara.league == self.viewModel.account.leagues[self.viewModel.leagueIndex]
                        {
                                characterCell(characterInfo: chara)
                        }
                    }
                }
                leaguePicker(viewModel: viewModel)
            }//.navigationBarTitle(Text("Characters"))
        }
        .padding(.top, -10.0)
        .navigationBarBackButtonHidden(true)
        
    }
}
#if DEBUG
struct CharacterSelectView_Previews: PreviewProvider {
    
    static var previews: some View {
        CharacterSelectView()
    }
}
#endif
