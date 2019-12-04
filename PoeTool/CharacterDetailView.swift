//
//  CharacterDetail.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/23.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
struct CharacterDetailView: View
{
    @ObservedObject var viewModel = CharacterDetailViewModel()
    @State var viewState: CGSize?
    @State var menuOpen = false
    @State var showDetail = true
    @State private var activeIdx: UUID = UUID()
    var banner : some View = Banner()
    var chara : CharacterInfo
    var body: some View
    {
        ZStack(alignment: .topLeading)
        {
            VStack
            {
                //banner
                if self.viewModel.catagoryItems.count > 0
                {
                    ForEach(0 ..< itemCategory.seqCases.count)
                    { number in
                        ZStack(alignment: .topLeading)
                        {
                        gridBackgroundView(cellProperty:itemCategory.seqCases[number].rawValue)
                            ForEach(self.viewModel.catagoryItems[number])
                            { item in
                                ItemView(item: item, cellSize: itemCategory.seqCases[number].rawValue.cellSize, actived: self.$activeIdx, isShowing: self.$showDetail)
                            }
                        }
                        .frame(width: itemCategory.seqCases[number].rawValue.cellSize * itemCategory.seqCases[number].rawValue.w, height: itemCategory.seqCases[number].rawValue.cellSize * itemCategory.seqCases[number].rawValue.h)
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                self.openMenu()
                }, label: {
                    Image(systemName: "line.horizontal.3")
            }))
            .navigationBarTitle(Text((viewModel.selectCharacter ?? CharacterInfo()).name).font(.system(size: 10)), displayMode: .inline)
            SideMenu(width: 200, isOpen: self.menuOpen, menuClose: self.openMenu)
        }
        .overlayPreferenceValue(itemPreferenceKey.self)
        { preferences in
            GeometryReader
            { geometry in
                if !self.showDetail
                {
                    self.viewModel.createBorder(geometry, preferences, activeIdx: self.activeIdx)
                }
            }
        }
        .onTapGesture
        {
            if !self.showDetail
            {
                self.showDetail = true
            }
        }
        .onAppear
        {
            self.viewModel.getItems(name: self.chara.name)
        }
        .onDisappear
        {
            //self.banner.hidden()
            //self.viewModel.clearItmes()
            self.showDetail = true
            //PoEData.shared.cancel()
        }
    }

    func openMenu()
    {
        menuOpen.toggle()
    }
}

#if DEBUG
    
    struct CharacterDetailView_Previews: PreviewProvider
    {
        static var previewChar = CharacterInfo()
        static var previews: some View
        {
            CharacterDetailView(chara: previewChar)
        }
    }
#endif
