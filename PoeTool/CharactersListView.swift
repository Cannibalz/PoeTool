//
// Created by 高梵 on 2019/10/14.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
struct leaguePicker: View
{
    @ObservedObject var viewModel : CharactersListViewModel
    var body : some View
    {
        Picker(selection: $viewModel.leagueIndex, label: Text("League"))
        {
            ForEach(0..<viewModel.leagues.count)
            { index in
                Text(self.viewModel.leagues[index]).tag(index)
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
                    Text(characterInfo.name).fontWeight(.medium)
                    Text(characterInfo.className).fontWeight(.light)
                    Text("\(characterInfo.level)").fontWeight(.light)
                    Text(characterInfo.league).fontWeight(.light)
                }
            }
//        }
    }
}

struct CharactersListView: View
{
    @State private var leagueIndex = 0
    @State private var selected : Int? = 0
    @State var menuOpen: Bool = false
    @ObservedObject var viewModel = CharactersListViewModel()
    var body : some View
    {
        ZStack
        {
            
            VStack
            {
                NavigationLink(destination: CharacterDetailView(), tag: 1, selection: $selected){EmptyView()}
                List(viewModel.charactersInfo,id:\.id)
                {
                    (chara) in
                    if self.viewModel.leagues[self.viewModel.leagueIndex] == "All"
                    {
                        characterCell(characterInfo: chara)
                        .gesture(TapGesture().onEnded
                        {dunnowtf in
                            self.selectCharacter(chara:chara)
                            self.selected = 1
                        })
                    }
                    else if chara.league == self.viewModel.leagues[self.viewModel.leagueIndex]
                    {
                        characterCell(characterInfo: chara)
                        .gesture(TapGesture().onEnded
                        {dunnowtf in
                            self.selectCharacter(chara:chara)
                            self.selected = 1
                        })
                    }
                }
                leaguePicker(viewModel: viewModel)
            }.navigationBarTitle(Text("Characters")).navigationBarBackButtonHidden(true)
            SideMenu(width: 200, isOpen: self.menuOpen, menuClose: self.openMenu)
        }
        .navigationBarItems(trailing: Button(action:
        {
            self.openMenu()
        }, label: {Image(systemName: "info.circle")}))
    }
    func selectCharacter(chara:CharacterInfo)
    {
        PoEData.shared.account.selectedCharacter = chara
        print(chara.id)
    }
    func openMenu() {
        self.menuOpen.toggle()
    }
}
#if DEBUG
struct CharactersListView_Previews: PreviewProvider {
    
    static var previews: some View {
        CharactersListView(viewModel: CharactersListViewModel())
    }
}
#endif
