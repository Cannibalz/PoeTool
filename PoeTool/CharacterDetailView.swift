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


struct CharacterDetailView:View
{
    @ObservedObject var viewModel : CharacterDetailViewModel
    init()
    {
        self.viewModel = CharacterDetailViewModel()
        //self.viewModel = CharacterDetailViewModel(char: charInfo)
    }
    @State var menuOpen = false
    var body: some View
    {
        ZStack
        {
            List{
                    
                
                VStack
                {
                    EquipmentlView()
                    ZStack
                    {
                        VStack(spacing:34)
                        {
                            ForEach(0..<3){_ in Divider()}
                        }
                        HStack(spacing:34)
                        {
                            ForEach(0..<6){_ in Divider()}
                        }
                    }.frame(width: 170, height: 68)
                    ZStack
                    {
                        VStack(spacing:20)
                        {
                            ForEach(0..<6){_ in Divider()}
                        }
                        HStack(spacing:20)
                        {
                            ForEach(0..<13){_ in Divider()}
                        }
                        ForEach(self.viewModel.mainInventory)
                        {item in
                            URLImage(URL(string: item.icon)!,processors: [Resize(size: CGSize(width: item.w*20, height: item.h*20), scale: UIScreen.main.scale)],content:{$0.image.resizable().aspectRatio(contentMode: .fill).clipped()}).frame(width:CGFloat(item.w*20),height: CGFloat(item.h*20))
                                .position(x: CGFloat(item.x*20), y: CGFloat(item.y*20))
                        }
                        
                    }.frame(width:20*12,height: 20*5)
            }
            .navigationBarItems(trailing: Button(action:
            {
                self.openMenu()
                }, label: {Image(systemName: "info.circle")}))
            .navigationBarTitle(Text(viewModel.selectCharacter!.name).font(.system(size: 10)), displayMode: .inline)
                }
            SideMenu(width: 200, isOpen: self.menuOpen, menuClose: self.openMenu)
        }.onAppear{
            self.viewModel.getItems()
        }
        .onDisappear
        {
            
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
