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
                    Divider().foregroundColor(.white).background(Color("GridColor"))
                }
            }
            VStack(spacing: (cellSize-0.5)) { //橫線
                ForEach(0..<h+1) { _ in
                    Divider().foregroundColor(.white).background(Color("GridColor"))
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
struct itemDetailView: View
{
    var body:some View
    {
        Text("1").background(Color.yellow)
    }
}
