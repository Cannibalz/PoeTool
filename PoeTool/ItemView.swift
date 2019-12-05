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

struct ItemView: View
{
    var item: Item
    let cellSize: CGFloat
    var offset: CGSize
    @Binding var actived: UUID
    @Binding var isShowing: Bool
    ////    @Binding var position : CGSize
    ////    init(_ item:Item, cellSize:Int)
    ////    {
    ////        self.item = item
    ////        self.cellSize = cellSize
    ////    }
    init(item: Item, cellSize: CGFloat, actived: Binding<UUID>, isShowing: Binding<Bool>)
    {
        self.item = item
        self.cellSize = cellSize
        _actived = actived
        _isShowing = isShowing
        offset = CGSize(width: CGFloat(item.x) * cellSize, height: CGFloat(item.y) * cellSize)
    }

    init(item: Item, cellSize: CGFloat, actived: Binding<UUID>, isShowing: Binding<Bool>, offset: CGSize)
    {
        self.item = item
        self.cellSize = cellSize
        _actived = actived
        _isShowing = isShowing
        self.offset = offset
    }

    var body: some View
    {
        ZStack(alignment: .topLeading)
        {
            URLImage(URL(string: item.icon)!, content: { $0.image.resizable().aspectRatio(contentMode: .fit).clipped() })
                .overlay(Text(item.stackSize
                        .flatMap
                    { x -> String in

                        if x > 1
                        {
                            return String(x)
                        }
                        else { return "" }

                } ?? ""), alignment: .topLeading).font(.system(size: 12))
                //.border(Color.yellow)
                .background(Color.blue.opacity(0.1))
                .frame(width: CGFloat(item.w) * cellSize, height: CGFloat(item.h) * cellSize)
                .offset(x: offset.width, y: offset.height)
                .anchorPreference(key: itemPreferenceKey.self, value: .topLeading, transform: { [itemPreferenceData(item: self.item, topLeading: $0, x: self.offset.width, y: self.offset.height)] })
                .transformAnchorPreference(key: itemPreferenceKey.self, value: .bottomTrailing, transform: { (value: inout [itemPreferenceData], anchor: Anchor<CGPoint>) in
                    value[0].bottomTrailing = anchor
                })
            
        }

        .onTapGesture
        {
            self.actived = self.item.uuID
            self.isShowing = !self.isShowing
        }
        
    }
}
