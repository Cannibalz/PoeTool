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
import URLImage
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
    let price : String
    @Binding var actived: UUID
    @Binding var isShowing: Bool
    //@Binding var searchText: String
    var BorderOrNot = 0
    ////    @Binding var position : CGSize
    ////    init(_ item:Item, cellSize:Int)
    ////    {
    ////        self.item = item
    ////        self.cellSize = cellSize
    ////    }
    init(item: Item, price:Double,cellSize: CGFloat, actived: Binding<UUID>, isShowing: Binding<Bool>, searchText : String)
    {
        self.item = item
        self.cellSize = cellSize
        _actived = actived
        _isShowing = isShowing
        //_searchText = searchText
        offset = CGSize(width: CGFloat(item.x) * cellSize, height: CGFloat(item.y) * cellSize)
        self.price = ItemView.totalPriceStr(price: price, stackSize: item.stackSize ?? 1)
        let mirrorOjb = Mirror(reflecting: item)
        self.BorderOrNot = 0
        for (index,attr) in mirrorOjb.children.enumerated()
        {
            let valueString = "\(attr.value)"
            if valueString.contains(searchText)
            {
                self.BorderOrNot = 1
            }
//            if let property_name = attr.label as String? {
//                print("Attr \(index): \(property_name) = \(attr.value)")
//            }
        }
//        print("1")
    }

    init(item: Item, price:Double, cellSize: CGFloat, actived: Binding<UUID>, isShowing: Binding<Bool>, offset: CGSize, searchText : String)
    {
        self.item = item
        self.cellSize = cellSize
        _actived = actived
        _isShowing = isShowing
//        _searchText = searchText
        self.offset = offset
        self.price = ItemView.totalPriceStr(price: price, stackSize: item.stackSize ?? 1)
        let mirrorOjb = Mirror(reflecting: item)
        self.BorderOrNot = 0
                for (index,attr) in mirrorOjb.children.enumerated()
                {
                    let valueString = "\(attr.value)"
                    if valueString.contains(searchText)
                    {
                        self.BorderOrNot = 2
                    }
        //            if let property_name = attr.label as String? {
        //                print("Attr \(index): \(property_name) = \(attr.value)")
        //            }
                }
    }
    static func totalPriceStr(price:Double,stackSize:Int)->String
    {
        let totalPrice = price*Double(stackSize)
        var str = String(format:"%.1f",totalPrice)
        if str == "0.0"
        {
            str = ""
        }
        return str
        
    }
    var body: some View
    {
        ZStack(alignment: .topLeading)
        {
            
            URLImage(URL(string: item.icon.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? "")!, content: { $0.image.resizable().aspectRatio(contentMode: .fit).clipped() })
                .overlay(Text(item.stackSize
                        .flatMap
                    { x -> String in

                        if x > 1
                        {
                            return String(x)
                        }
                        else { return "" }

                    } ?? "").background(Color.alphaBackground()), alignment: .topLeading).font(.system(size: 12))
                .border(Color.white, width: CGFloat(BorderOrNot))
                .overlay(Text(price).background(Color.alphaBackground()), alignment: .bottomTrailing).font(.system(size: 12))
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
