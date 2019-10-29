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
            Text("Equipment").position(x: 190, y: 50)
            
        }.frame(width: 272, height: 204)
    }
}
class EquipmentViewModel : ObservableObject
{
    
}
