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
    
    var translation: CGSize{
        switch self{
        case .inactive, .pressing:
            return .zero
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
    @GestureState var pressState = PressState.inactive
    @State var viewState = CGSize.zero
    @State var menuOpen = false
    @State var showDetail = false
    
    var body: some View {
        let longPress = LongPressGesture(minimumDuration: 0)
            .sequenced(before: DragGesture())
            .updating($pressState){ value, state, _ in
                self.showDetail = true
            }.onEnded{ value in
                self.showDetail = false
            }
        return(
        ZStack {
            VStack {
                ZStack(alignment:.topLeading){
                    gridBackgroundView(cellSize: 50, w: 8, h: 6)
                        ForEach(self.viewModel.Equipment){item in
                            itemView(item,cellSize:50).gesture(LongPressGesture(minimumDuration: 1)
                            .sequenced(before: DragGesture())
                                .updating(self.$pressState){ value, state, _ in
                                self.showDetail = true
                            }.onEnded{ value in
                                self.showDetail = false
                            })
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
