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

let cellSize = CGFloat(30)

struct CharacterDetailView: View {
    @ObservedObject var viewModel: CharacterDetailViewModel

    init() {
        self.viewModel = CharacterDetailViewModel()
        //self.viewModel = CharacterDetailViewModel(char: charInfo)
    }

    @State var menuOpen = false
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    EquipmentlView()
                    ZStack {
                        VStack(spacing: 30) {
                            ForEach(0..<3) { _ in
                                Divider()
                            }
                        }
                        HStack(spacing: 30) {
                            ForEach(0..<6) { _ in
                                Divider()
                            }
                        }
                    }.frame(width: 30 * 5, height: 30 * 2)
                    ZStack {
                        VStack(spacing: 30) {
                            ForEach(0..<6) { _ in
                                Divider()
                            }
                        }
                        HStack(spacing: 30) {
                            ForEach(0..<13) { _ in
                                Divider()
                            }
                        }
                        ForEach(self.viewModel.mainInventory) {
                            item in
                            URLImage(URL(string: item.icon)!, processors: [Resize(size: CGSize(width: item.w * 30, height: item.h * 30), scale: UIScreen.main.scale)], content: { $0.image.resizable().aspectRatio(contentMode: .fill).clipped() }).frame(width: CGFloat(item.w * 20), height: CGFloat(item.h * 30))
                                    .position(x: CGFloat(item.x * 30), y: CGFloat(item.y * 30))
                        }

                    }.frame(width: 20 * 12, height: 20 * 5)
                }
                        .navigationBarItems(trailing: Button(action: {
                            self.openMenu()
                        }, label: {
                            Image(systemName: "info.circle")
                        }))
                        .navigationBarTitle(Text(viewModel.selectCharacter!.name).font(.system(size: 10)), displayMode: .inline)
            }
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
