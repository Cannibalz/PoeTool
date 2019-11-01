//
//  EquipmentView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/28.
//  Copyright © 2019 KaFn. All rights reserved.
//
import SwiftUI
import Combine
import Foundation
struct EquipmentlView:View
{
    var body : some View
    {
        ZStack
        {
            VStack(spacing:20)
            {
                ForEach(0..<7){_ in Divider()}
            }
            HStack(spacing:20)
            {
                ForEach(0..<9){_ in Divider()}
            }
            URLImage(URL(string: "https://web.poecdn.com/image/Art/2DItems/Armours/Boots/Alberonswarpath.png?scale=1&w=2&h=2&v=354e2b293d5c3878e906730b17d2cb6d")!,processors: [Resize(size: CGSize(width: 40, height: 40), scale: UIScreen.main.scale)],content:{$0.image.resizable().aspectRatio(contentMode: .fill).clipped()}).frame(width:40,height: 40)
                .position(x: 20, y: 20)
        }.frame(width: 20*8, height: 20*6)
    }
}
class EquipmentViewModel : ObservableObject
{
    
}
