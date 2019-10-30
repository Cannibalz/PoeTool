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
            VStack(spacing:34)
            {
                ForEach(0..<7){_ in Divider()}
            }
            HStack(spacing:34)
            {
                ForEach(0..<9){_ in Divider()}
            }
//            URLImage(URL(string: "https://web.poecdn.com/image/Art/2DItems/Armours/Boots/Alberonswarpath.png?scale=1&w=2&h=2&v=354e2b293d5c3878e906730b17d2cb6d")!,processors: [Resize(size: CGSize(width: 68, height: 68), scale: UIScreen.main.scale)],content:{$0.image.resizable().aspectRatio(contentMode: .fill).clipped()}).frame(width:68,height: 68)
//                .position(x: 34, y: 34)
        }.frame(width: 272, height: 204)
    }
}
class EquipmentViewModel : ObservableObject
{
    
}
