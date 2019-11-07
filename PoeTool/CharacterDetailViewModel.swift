//
//  CharacterDetailViewModel.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/23.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import SwiftUI

class CharacterDetailViewModel: ObservableObject {
    @Published var selectCharacter: CharacterInfo?
    @Published var items: [Item] = [Item]()
    @Published var mainInventory: [Item] = [Item]()
    @Published var Flask: [Item] = [Item]()
    @Published var Equipment: [Item] = [Item]()
    @Published var catagoryItmes = [String:[Item]]()
    enum itemCategory : String, CaseIterable {
        case mainInventroy = "mainInventroy"
        case Flask = "Flask"
        case Equipment = "Equipment"
    }
    init(char: CharacterInfo) {
        self.selectCharacter = char
    }

    init() {
    }

    func clearItmes() {
        self.mainInventory = [Item]()
        self.Flask = [Item]()
        self.Equipment = [Item]()
    }

    func getItems() {
        PoEData.shared.getCharactersItems(name: selectCharacter!.name) { Detail in
            self.items = Detail.items
            print(self.items.count)
            var tempMainInventory = [Item]()
            var tempFlask = [Item]()
            var tempEquipment = [Item]()

            self.items.forEach { item in
                if item.inventoryID == "MainInventory" {
                    tempMainInventory.append(item)
                } else if item.inventoryID == "Flask" {
                    tempFlask.append(item)
                } else {
                    var tempItem = item
                    switch item.inventoryID {
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
            self.catagoryItmes.updateValue(tempMainInventory, forKey: itemCategory.mainInventroy.rawValue)
            self.catagoryItmes.updateValue(tempFlask, forKey:itemCategory.Flask.rawValue)
            self.catagoryItmes.updateValue(tempEquipment, forKey: itemCategory.Equipment.rawValue)
            //print(self.Equipment[0])
        }
    }
}
