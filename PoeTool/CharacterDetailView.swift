//
//  CharacterDetail.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/23.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
enum PressState{
    case inactive
    case pressing
    case dragging(translation:CGSize)
    
    var translation: CGSize?{
        switch self{
        case .inactive, .pressing:
            return nil
        case .dragging(let translation):
            return translation
        }
    }
    var isActive: Bool{
        switch self{
        case .inactive:
            return false
        case .pressing, .dragging:
            return true
        }
    }
    var isDragging: Bool{
        switch self{
        case .inactive, .pressing:
            return false
        case .dragging:
            return true
            
        }
    }
}

struct CharacterDetailView: View {
    @ObservedObject var viewModel: CharacterDetailViewModel
    let cellSize : CGFloat = 30
    init() {
        self.viewModel = CharacterDetailViewModel()
        //self.viewModel = CharacterDetailViewModel(char: charInfo)
    }
    @GestureState var dragState = PressState.inactive
//    @State var viewState : CGSize?
    @State var menuOpen = false
    @State var showDetail = false
    
    var body: some View {
        let minimumLongPressDuration = 0.1
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
           .sequenced(before: DragGesture())
           .updating($dragState) { value, state, transaction in
               switch value {
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
           .onEnded { value in
               guard case .second(true, let drag?) = value else { return }
//               self.viewState!.width = 0
//               self.viewState!.height = 0
           }
        return(
        ZStack(alignment:.topLeading) {
            VStack {
                ZStack(alignment:.topLeading){
                    gridBackgroundView(cellSize: 50, w: 8, h: 6)
                        ForEach(self.viewModel.Equipment){item in
                            itemView(item,cellSize:50)
//                                .offset(
//                                x: self.dragState.translation?.width ?? 0,
//                                y: self.dragState.translation?.height ?? 0)
                                .animation(.default).gesture(longPressDrag)
                    }
                    }.frame(width: 50 * 8, height: 50 * 6)
                
                    ZStack(alignment: .topLeading) {
                    gridBackgroundView(cellSize: 50, w: 5, h: 2)
                    ForEach(self.viewModel.Flask){item in
                            itemView(item,cellSize:50)
                        }
                    }.frame(width: 50 * 5, height: 50 * 2)
                    ZStack(alignment: .topLeading) {
                        gridBackgroundView(cellSize: 30, w: 12, h: 5)
                        ForEach(self.viewModel.mainInventory) {item in
                            itemView(item,cellSize: 30)
                        }
                    }.frame(width: 30 * 12, height: 30 * 5)
            }
            .navigationBarItems(trailing: Button(action: {
                self.openMenu()
            }, label: {
                Image(systemName: "info.circle")
            }))
            .navigationBarTitle(Text(viewModel.selectCharacter!.name).font(.system(size: 10)), displayMode: .inline)
            SideMenu(width: 200, isOpen: self.menuOpen, menuClose: self.openMenu)
            GeometryReader{ geo in
                itemDetailView().offset(
                    x: self.dragState.translation?.width ?? 640,
                    y: self.dragState.translation?.height ?? 640)
            }
            
        }.onAppear {
            self.viewModel.getItems()
        }
        .onDisappear {
            self.viewModel.clearItmes()
        })
    }

    func openMenu() {
        self.menuOpen.toggle()
    }
}

#if DEBUG
var char = CharacterInfo()

struct CharacterDetailView_Previews: PreviewProvider {

    static var previews: some View {
        CharacterDetailView()
    }
}
#endif
