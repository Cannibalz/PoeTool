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
    let item : Item
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
    var cellSize: CGFloat
    var w, h: CGFloat
    var body: some View
    {
        ZStack
        {
            HStack(spacing: cellSize - 0.5)
            { // 直線
                ForEach(0 ..< Int(w) + 1)
                { _ in
                    Divider().foregroundColor(.white).background(Color("GridColor"))
                }
            }
            VStack(spacing: cellSize - 0.5)
            { // 橫線
                ForEach(0 ..< Int(h) + 1)
                { _ in
                    Divider().foregroundColor(.white).background(Color("GridColor"))
                }
            }
        }
    }
}

struct itemView: View
{
    let item: Item
    let cellSize: CGFloat
    @Binding var actived: UUID
    @Binding var isShowing: Bool
//    @Binding var position : CGSize
//    init(_ item:Item, cellSize:Int)
//    {
//        self.item = item
//        self.cellSize = cellSize
//    }
    var body: some View
    {
        ZStack(alignment:.topLeading)
        {
            URLImage(URL(string: item.icon)!, content: { $0.image.resizable().aspectRatio(contentMode: .fit).clipped() })
            .offset(x: CGFloat(item.x) * cellSize, y: CGFloat(item.y) * cellSize)
            .frame(width: CGFloat(item.w) * cellSize, height: CGFloat(item.h) * cellSize)
            .anchorPreference(key: itemPreferenceKey.self, value: .topLeading, transform: { [itemPreferenceData(item: self.item, topLeading: $0, x: CGFloat(self.item.x) * self.cellSize, y: CGFloat(self.item.y) * self.cellSize)] })
            .transformAnchorPreference(key: itemPreferenceKey.self, value: .bottomTrailing, transform: { (value: inout [itemPreferenceData], anchor: Anchor<CGPoint>) in
                value[0].bottomTrailing = anchor

            })
            if item.stackSize != 1 && item.stackSize != nil
            {
                Text("\(item.stackSize!)").font(.system(size: 10)).bold()
                .offset(x: CGFloat(item.x) * cellSize, y: CGFloat(item.y) * cellSize)
            }
        }
            .onTapGesture
        {
            self.actived = self.item.uuID
            self.isShowing = !self.isShowing
        }
    }
}
