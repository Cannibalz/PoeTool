//
// Created by 高梵 on 2019/10/14.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
struct leaguePicker: View
{
    @ObservedObject var viewModel: CharactersListViewModel
    var body: some View
    {
        Picker(selection: $viewModel.leagueIndex, label: Text("League"))
        {
            ForEach(0 ..< viewModel.leagues.count)
            { index in
                Text(self.viewModel.leagues[index]).tag(index)
//                Text("\(index)")
            }
        }.padding(.bottom, 30.0).pickerStyle(SegmentedPickerStyle())
    }
}

struct characterCell: View
{
    var characterInfo: CharacterInfo
    var body: some View
    {
        HStack
        {
            Image(characterInfo.className)
                .resizable()
                .frame(width: 106 * 1.3, height: 49 * 1.3)

            VStack(alignment: .leading)
            {
                Text(characterInfo.name).fontWeight(.medium)
                Text(characterInfo.className).fontWeight(.light)
                Text("\(characterInfo.level)").fontWeight(.light)
                Text(characterInfo.league).fontWeight(.light)
            }
        }
    }
}

struct CharactersListView: View
{
    @State private var leagueIndex = 0
    @State private var selected: Int? = 0
    @State var menuOpen: Bool = false
    @State var selectedChar: CharacterInfo = CharacterInfo()
    @Binding var logInSuccess : Bool
    @ObservedObject var viewModel = CharactersListViewModel(isLogged: PoEData.shared.isLogged)
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                VStack
                {
                    Banner()
                    if self.viewModel.leagues.count > 0
                    {
                        if self.viewModel.leagueIndex != 0
                        {
                            Spacer()
                            NavigationLink(destination: StashsView(leagueName: self.viewModel.leagues[self.viewModel.leagueIndex]))
                            {
                                Text("  Stash of \(self.viewModel.leagues[self.viewModel.leagueIndex]) league  ").foregroundColor(Color.secondary).cornerRadius(10).frame(height: 50, alignment: .center).overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.secondary, lineWidth: 2))
                            }
                        }
                    }
                    List
                    {
                        ForEach(viewModel.charactersInfo)
                        { chara in
                            if self.viewModel.leagueIndex == 0
                                || chara.league == self.viewModel.leagues[self.viewModel.leagueIndex]
                            {
                                NavigationLink(destination: CharacterDetailView(chara: chara))
                                {
                                    characterCell(characterInfo: chara).disabled(false)
                                }
                            }
                        }
                    }
                    if viewModel.charactersInfo.count > 0
                    {
                        leaguePicker(viewModel: viewModel)
                    }
                }.navigationBarTitle(Text("Characters")).navigationBarBackButtonHidden(true)
                SideMenu(width: 200, isOpen: self.menuOpen, menuClose: self.openMenu)
            }
            .navigationBarItems(trailing: Button(action:
                {
                    UserDefaults.standard.set(false ,forKey:"wannaStore")
                    UserDefaults.standard.set("" ,forKey:"accName")
                    UserDefaults.standard.set("" ,forKey:"POESSID")
                    PoEData.shared.account = Account()
                    PoEData.shared.isLogged = false
                    self.logInSuccess = false
            }, label: { Text("Log out").foregroundColor(Color.red) }))
                
            .onAppear(perform: {
                self.viewModel.viewOnApper()
                self.selected = 0
            })
            .onDisappear
            {
            }
        }
    }

    func selectCharacter(chara: CharacterInfo)
    {
        $selectedChar.wrappedValue = chara
        print(selectedChar)
        selected = 1
    }

    func openMenu()
    {
        menuOpen.toggle()
    }
}

#if DEBUG
    struct CharactersListView_Previews: PreviewProvider
    {
        static var previews: some View
        {
            CharactersListView(logInSuccess: .constant(true), viewModel: CharactersListViewModel(isLogged: true))
        }
    }
#endif
