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
    @ObservedObject var viewModel: CharacterDetailViewModel
    let cellSize: CGFloat = 30

    init()
    {
        viewModel = CharacterDetailViewModel()
        // self.viewModel = CharacterDetailViewModel(char: charInfo)
    }

    @GestureState var dragState = PressState.inactive
    @State var viewState: CGSize?
    @State var menuOpen = false
    @State var showDetail = false
    @State private var activeIdx: UUID = UUID()
    var TTgesture = ToolTipGesture()

    var body: some View
    {
        let minimumLongPressDuration = 0.1
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture())
            .updating($dragState)
        { value, state, _ in
            switch value
            {
            // Long press begins.
            case .first(true):
                state = .pressing
            // Long press confirmed, dragging may begin.
            case .second(true, let drag):
                state = .dragging(translation: drag?.translation ?? CGSize.zero)
            // Dragging ended or the long press cancelled.
            default:
                state = .inactive
            }
        }
        .onEnded
        { value in
            guard case .second(true, let drag?) = value else
            {
                return
            }
        }
        return (
            ZStack(alignment: .topLeading)
            {
                VStack
                {
                    if self.viewModel.catagoryItems.count > 0
                    {
                        ForEach(0 ..< itemCategory.allCases.count)
                        { number in
                            ZStack(alignment: .topLeading)
                            {
                                gridBackgroundView(cellSize: itemCategory.allCases[number].rawValue.cellSize, w: itemCategory.allCases[number].rawValue.w, h: itemCategory.allCases[number].rawValue.h)
                                ForEach(self.viewModel.catagoryItems[number])
                                { item in
                                    itemView(item: item, cellSize: itemCategory.allCases[number].rawValue.cellSize, actived: self.$activeIdx)//.gesture(longPressDrag)
                                }
                            }
                            .frame(width: itemCategory.allCases[number].rawValue.cellSize * itemCategory.allCases[number].rawValue.w, height: itemCategory.allCases[number].rawValue.cellSize * itemCategory.allCases[number].rawValue.h)
                        }
                    }
                }
                .backgroundPreferenceValue(itemPreferenceKey.self)
                { preferences in
                    GeometryReader
                    { geometry in
                        ZStack(alignment: .topLeading)
                        {
                            self.createBorder(geometry, preferences)
                            itemToolTipView().offset(
                            x: self.dragState.translation?.width ?? 0,
                            y: self.dragState.translation?.height ?? 0).frame(alignment: .topLeading).position(x: 125, y: 50)
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                }
                .navigationBarItems(trailing: Button(action: {
                    self.openMenu()
                    }, label: {
                        Image(systemName: "info.circle")
                }))
                .navigationBarTitle(Text(viewModel.selectCharacter!.name).font(.system(size: 10)), displayMode: .inline)
                SideMenu(width: 200, isOpen: self.menuOpen, menuClose: self.openMenu)
//                GeometryReader
//                { _ in
//                    itemToolTipView().offset(
//                        x: self.dragState.translation?.width ?? 640,
//                        y: self.dragState.translation?.height ?? 640).frame(alignment: .topLeading).position(x: 125, y: 50)
//                }.frame(alignment: .center)
            }
            .onAppear
            {
                self.viewModel.getItems()
            }
            .onDisappear
            {
                self.viewModel.clearItmes()
        })
    }

    func openMenu()
    {
        menuOpen.toggle()
    }

    func createBorder(_ geometry: GeometryProxy, _ preferences: [itemPreferenceData]) -> some View
    {
        let p = preferences.first(where: { $0.viewIdx == self.activeIdx })
        let aTopLeading = p?.topLeading
        let aBottomTrailing = p?.bottomTrailing
        let x = p?.x
        let y = p?.y
        let topLeading = aTopLeading != nil ? geometry[aTopLeading!] : .zero
        let bottomTrailing = aBottomTrailing != nil ? geometry[aBottomTrailing!] : .zero

        return ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 15)
            .stroke(lineWidth: 3.0)
            .foregroundColor(Color.green)
            .frame(width: bottomTrailing.x - topLeading.x, height: bottomTrailing.y - topLeading.y)
            .fixedSize()
            .offset(x: topLeading.x + (x ?? 0), y: topLeading.y + (y ?? 0))
            .animation(nil)
            itemToolTipView().offset(x: topLeading.x + (x ?? 0), y: topLeading.y + (y ?? 0))
        }
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
