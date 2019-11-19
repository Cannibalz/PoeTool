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
    var body: some View
    {
        ZStack(alignment: .topLeading)
        {
            VStack
            {
                Banner()
                if self.viewModel.catagoryItems.count > 0
                {
                    ForEach(0 ..< itemCategory.allCases.count)
                    { number in
                        ZStack(alignment: .topLeading)
                        {
                            gridBackgroundView(cellSize: itemCategory.allCases[number].rawValue.cellSize, w: itemCategory.allCases[number].rawValue.w, h: itemCategory.allCases[number].rawValue.h)
                            ForEach(self.viewModel.catagoryItems[number])
                            { item in
                                itemView(item: item, cellSize: itemCategory.allCases[number].rawValue.cellSize, actived: self.$activeIdx, isShowing: self.$showDetail)
                            }
                        }
                        .frame(width: itemCategory.allCases[number].rawValue.cellSize * itemCategory.allCases[number].rawValue.w, height: itemCategory.allCases[number].rawValue.cellSize * itemCategory.allCases[number].rawValue.h)
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                self.openMenu()
                }, label: {
                    Image(systemName: "line.horizontal.3")
            }))
            .navigationBarTitle(Text(viewModel.selectCharacter!.name).font(.system(size: 10)), displayMode: .inline)
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
            self.viewModel.getItems()
        }
        .onDisappear
        {
            self.viewModel.clearItmes()
            self.showDetail = true
        }
    }

    func openMenu()
    {
        menuOpen.toggle()
    }
}

#if DEBUG
    var char = CharacterInfo()

    struct CharacterDetailView_Previews: PreviewProvider
    {
        static var previews: some View
        {
            CharacterDetailView()
        }
    }
#endif
