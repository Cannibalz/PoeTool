//
//  CharacterDetailViewModel.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/23.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import SwiftUI

class CharacterDetailViewModel : ObservableObject
{
    @Published var selectCharacter:CharacterInfo?
    @Published var items:[Item] = [Item]()
    @Published var mainInventory:[Item] = [Item]()
    init(char:CharacterInfo)
    {
        self.selectCharacter = char
    }
    init(){}
    func getItems()
    {
        PoEData.shared.getCharactersItems(name:selectCharacter!.name)
        {Detail in
            self.items = Detail.items
            print(self.items.count)
            var tempMainInventory = [Item]()
            self.items.forEach
            {item in
                if item.inventoryID == "MainInventory"
                {
                    tempMainInventory.append(item)
                }
            }
            self.mainInventory = tempMainInventory
            print(tempMainInventory.count)
        }
    }
}
