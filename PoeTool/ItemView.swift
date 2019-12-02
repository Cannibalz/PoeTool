//
import Combine
import Foundation
//  EquipmentView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/28.
//  Copyright © 2019 KaFn. All rights reserved.
//
import SwiftUI

struct itemPreferenceData
{
    let item: Item
    var topLeading: Anchor<CGPoint>?
    var bottomTrailing: Anchor<CGPoint>?
    var x: CGFloat
    var y: CGFloat
}

struct itemPreferenceKey: PreferenceKey
{
    typealias Value = [itemPreferenceData]

    static var defaultValue: [itemPreferenceData] = []

    static func reduce(value: inout [itemPreferenceData], nextValue: () -> [itemPreferenceData])
    {
        value.append(contentsOf: nextValue())
    }
}

struct gridBackgroundView: View
{
    var cellProperty: cellProperty
    var body: some View
    {
        ZStack
        {
            HStack(spacing: cellProperty.cellSize - 0.5)
            { // 直線
                ForEach(0 ..< Int(cellProperty.w) + 1)
                { _ in
                    Divider().foregroundColor(.white).background(Color("GridColor"))
                }
            }
            VStack(spacing: cellProperty.cellSize - 0.5)
            { // 橫線
                ForEach(0 ..< Int(cellProperty.h) + 1)
                { _ in
                    Divider().foregroundColor(.white).background(Color("GridColor"))
                }
            }
        }
    }
}

struct itemView: View
{
    var item: Item
    let cellSize: CGFloat
    @Binding var actived: UUID
    @Binding var isShowing: Bool
////    @Binding var position : CGSize
////    init(_ item:Item, cellSize:Int)
////    {
////        self.item = item
////        self.cellSize = cellSize
////    }
    init(item:Item, cellSize:CGFloat, actived: Binding<UUID>, isShowing:Binding<Bool>)
    {
        self.item = item
        self.cellSize = cellSize
        self._actived = actived
        self._isShowing = isShowing
        print("---")
        print(self.item.x)
        print(self.item.y)
        
    }
    init(item:Item, cellSize:CGFloat, actived: Binding<UUID>, isShowing:Binding<Bool>, offset : CGSize)
    {
        self.item = item
        self.cellSize = cellSize
        self._actived = actived
        self._isShowing = isShowing
        self.item.x = Int(offset.width)
        self.item.y = Int(offset.height)
        print("---")
        print(self.item.x)
        print(self.item.y)
        print("---")
    }
    var body: some View
    {
        ZStack(alignment: .topLeading)
        {
            URLImage(URL(string: item.icon)!, content: { $0.image.resizable().aspectRatio(contentMode: .fit).clipped() })
                .overlay(Text("\(item.stackSize.flatMap(String.init) ?? "")"))
                .offset(x: CGFloat(item.x) * cellSize, y: CGFloat(item.y) * cellSize)
                .frame(width: CGFloat(item.w) * cellSize, height: CGFloat(item.h) * cellSize)
                .anchorPreference(key: itemPreferenceKey.self, value: .topLeading, transform: { [itemPreferenceData(item: self.item, topLeading: $0, x: CGFloat(self.item.x) * self.cellSize, y: CGFloat(self.item.y) * self.cellSize)] })
                .transformAnchorPreference(key: itemPreferenceKey.self, value: .bottomTrailing, transform: { (value: inout [itemPreferenceData], anchor: Anchor<CGPoint>) in
                    value[0].bottomTrailing = anchor
                })
                .background(Color.blue.opacity(0.1).offset(x: CGFloat(item.x) * cellSize, y: CGFloat(item.y) * cellSize))
//            if item.stackSize != 1 && item.stackSize != nil
//            {
//                Text("\(item.stackSize!)").font(.system(size: 10)).bold()
//                    .offset(x: CGFloat(item.x) * cellSize, y: CGFloat(item.y) * cellSize)
//            }
            //寫進道具中
        }
        .onTapGesture
        {
            self.actived = self.item.uuID
            self.isShowing = !self.isShowing
        }
    }
}
