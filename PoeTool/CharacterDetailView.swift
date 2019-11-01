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

struct gridBackgroundView: View
{
    var cellSize : CGFloat
    var w,h : Int
    init(cellSize:CGFloat,w:Int,h:Int)
    {
        self.cellSize = cellSize
        self.w = w
        self.h = h
    }
    var body: some View
    {
        ZStack
        {
            HStack(spacing: (cellSize-0.5)) { //直線
                ForEach(0..<w+1) { _ in
                    Divider()
                }
            }
            VStack(spacing: (cellSize-0.5)) { //橫線
                ForEach(0..<h+1) { _ in
                    Divider()
                }
            }
            
        }
    }
}

struct itemView: View
{
    var item : Item
    var cellSize : Int
    init(_ item:Item, cellSize:Int)
    {
        self.item = item
        self.cellSize = cellSize
    }
    var body: some View
    {
        URLImage(URL(string: item.icon)!, content: { $0.image.resizable().aspectRatio(contentMode: .fit).clipped() })
        .frame(width: CGFloat(item.w * cellSize), height: CGFloat(item.h * cellSize))
        .offset(x: CGFloat(item.x*cellSize), y: CGFloat(item.y*cellSize))
    }
}
struct CharacterDetailView: View {
    @ObservedObject var viewModel: CharacterDetailViewModel
    let cellSize : CGFloat = 30
    init() {
        self.viewModel = CharacterDetailViewModel()
        //self.viewModel = CharacterDetailViewModel(char: charInfo)
    }

    @State var menuOpen = false
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment:.topLeading){
                    gridBackgroundView(cellSize: 30, w: 8, h: 6)
                        ForEach(self.viewModel.Equipment){item in
                            itemView(item,cellSize:30)
                        }
                    }.frame(width: 30 * 8, height: 30 * 6)
                
                    ZStack(alignment: .topLeading) {
                    gridBackgroundView(cellSize: 30, w: 5, h: 2)
                    ForEach(self.viewModel.Flask){item in
                            itemView(item,cellSize:30)
                        }
                    }.frame(width: 30 * 5, height: 30 * 2)
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

                }
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
