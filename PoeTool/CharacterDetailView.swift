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

enum PressState
{
    case inactive
    case pressing
    case dragging(translation: CGSize)

    var translation: CGSize?
    {
        switch self
        {
        case .inactive, .pressing:
            return nil
        case let .dragging(translation):
            return translation
        }
    }

    var isActive: Bool
    {
        switch self
        {
        case .inactive:
            return false
        case .pressing, .dragging:
            return true
        }
    }

    var isDragging: Bool
    {
        switch self
        {
        case .inactive, .pressing:
            return false
        case .dragging:
            return true
        }
    }
}
class Index
{
    static var num = 0
}
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
                    ForEach(0..<1)
                    { number in
                        ZStack(alignment: .topLeading)
                        {
                            gridBackgroundView(cellSize: 50, w: 8, h: 6)
                            ForEach(self.viewModel.catagoryItmes[itemCategory.allCases[number].rawValue] ?? [])
                            { item in
                                itemView(item: item, cellSize: 50, actived: self.$activeIdx).gesture(longPressDrag)
                            }
                        }.frame(width: 50 * 8, height: 50 * 6)
                    }
                    ZStack(alignment: .topLeading)
                    {
                        gridBackgroundView(cellSize: 50, w: 8, h: 6)
                        ForEach(self.viewModel.Equipment)
                        { item in
                            itemView(item: item, cellSize: 50, actived: self.$activeIdx).gesture(longPressDrag)
                        }
                    }.frame(width: 50 * 8, height: 50 * 6)
                    ZStack(alignment: .topLeading)
                    {
                        gridBackgroundView(cellSize: 50, w: 5, h: 2)
                        ForEach(self.viewModel.Flask)
                        { item in
                            itemView(item: item, cellSize: 50, actived: self.$activeIdx)
                        }
                    }.frame(width: 50 * 5, height: 50 * 2)
                    ZStack(alignment: .topLeading)
                    {
                        gridBackgroundView(cellSize: 30, w: 12, h: 5)
                        ForEach(self.viewModel.mainInventory)
                        { item in
                            itemView(item: item, cellSize: 30, actived: self.$activeIdx)
                        }
                    }.frame(width: 30 * 12, height: 30 * 5)
                }
                .backgroundPreferenceValue(itemPreferenceKey.self)
                { preferences in
                    GeometryReader
                    { geometry in
                        ZStack
                        {
                            self.createBorder(geometry, preferences)
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
                GeometryReader
                { _ in
                    itemDetailView().offset(
                        x: self.dragState.translation?.width ?? 640,
                        y: self.dragState.translation?.height ?? 640).frame(alignment: .topLeading).position(x: 125, y: 50)
                }.frame(alignment: .center)
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
        

        return RoundedRectangle(cornerRadius: 15)
            .stroke(lineWidth: 3.0)
            .foregroundColor(Color.green)
            .frame(width: bottomTrailing.x - topLeading.x, height: bottomTrailing.y - topLeading.y)
            .fixedSize()
            .offset(x: topLeading.x + (x ?? 0), y: topLeading.y + (y ?? 0))
            .animation(nil)
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
