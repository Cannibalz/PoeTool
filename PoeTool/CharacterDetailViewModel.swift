//
//  CharacterDetailViewModel.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/23.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import SwiftUI
struct cellProperty: ExpressibleByStringLiteral, Equatable
{
    let name: String
    let w, h: CGFloat
    let cellSize: CGFloat
    public static func == (lhs: cellProperty, rhs: cellProperty) -> Bool
    {
        return true
    }
    public init(stringLiteral value: String)
    {
        let components = value.components(separatedBy: ",")
        name = components[0]
        w = CGFloat(truncating: NumberFormatter().number(from: components[1]) ?? 0)
        h = CGFloat(truncating: NumberFormatter().number(from: components[2]) ?? 0)
        cellSize = CGFloat(truncating: NumberFormatter().number(from: components[3]) ?? 0)
    }
}

enum itemCategory: cellProperty
{
    case Equipment = "Equipment,8,6,50"
    case Flask = "Flask,5,2,50"
    case mainInventroy = "mainInventroy,12,5,30"

    static var allCases: [itemCategory]
    {
        return [.Equipment, .Flask, .mainInventroy]
    }
}

class CharacterDetailViewModel: ObservableObject
{
    @Published var selectCharacter: CharacterInfo?
    @Published var items: [Item] = [Item]()
    @Published var catagoryItems = [[Item]]()
    @Published var dragState = PressState.inactive
    init(char: CharacterInfo)
    {
        selectCharacter = char
    }

    init()
    {
    }

    func clearItmes()
    {
        catagoryItems = [[Item]]()
    }

    func getItems()
    {
        PoEData.shared.getCharactersItems(name: selectCharacter!.name)
        { Detail in
            self.items = Detail.items
            print(self.items.count)
            var tempMainInventory = [Item]()
            var tempFlask = [Item]()
            var tempEquipment = [Item]()

            self.items.forEach
            { item in
                if item.inventoryID == "MainInventory"
                {
                    tempMainInventory.append(item)
                }
                else if item.inventoryID == "Flask"
                {
                    tempFlask.append(item)
                }
                else
                {
                    var tempItem = item
                    switch item.inventoryID
                    {
                    case "Helm":
                        tempItem.x = 3
                        tempItem.y = 0
                    case "BodyArmour":
                        tempItem.x = 3
                        tempItem.y = 2
                    case "Belt":
                        tempItem.x = 3
                        tempItem.y = 5
                    case "Weapon":
                        tempItem.x = 0
                        tempItem.y = 0
                        tempItem.w = 2
                        tempItem.h = 4
                    case "Weapon2":
                        tempItem.x = 2
                        tempItem.y = 0
                        tempItem.w = 1
                        tempItem.h = 2
                    case "Offhand":
                        tempItem.x = 6
                        tempItem.y = 0
                        tempItem.w = 2
                        tempItem.h = 4
                    case "Offhand2":
                        tempItem.x = 5
                        tempItem.y = 0
                        tempItem.w = 1
                        tempItem.h = 2
                    case "Gloves":
                        tempItem.x = 0
                        tempItem.y = 4
                    case "Boots":
                        tempItem.x = 6
                        tempItem.y = 4
                    case "Amulet":
                        tempItem.x = 5
                        tempItem.y = 2
                    case "Ring":
                        tempItem.x = 2
                        tempItem.y = 3
                    case "Ring2":
                        tempItem.x = 5
                        tempItem.y = 3
                    default:
                        return
                    }
                    tempEquipment.append(tempItem)
                }
            }
            self.catagoryItems.append(tempEquipment)
            self.catagoryItems.append(tempFlask)
            self.catagoryItems.append(tempMainInventory)
        }
    }
    func setDragGesture()->LongPressGesture
    {
        return LongPressGesture()
    }
    func createBorder(_ geometry: GeometryProxy, _ preferences: [itemPreferenceData],activeIdx : UUID) -> some View
    {
        let p = preferences.first(where: { $0.item.uuID == activeIdx })
        let aTopLeading = p?.topLeading
        let x = p?.x
        let y = p?.y
        let topLeading = aTopLeading != nil ? geometry[aTopLeading!] : .zero
        return itemToolTipView(item: p!.item).offset(x: topLeading.x + (x ?? 640), y: topLeading.y + (y ?? 640)).background(Color.black.opacity(0.5).offset(x: topLeading.x + (x ?? 640), y: topLeading.y + (y ?? 640)))
    }
}
