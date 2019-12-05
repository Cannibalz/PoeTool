//
//  StashsJSON.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/21.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation

struct parserStash: Codable {
    let numTabs: Int
    let tabLayout : [String: TabLayout]?
    let tabsInfo: [TabsInfo]?
    let items: [Item]
    enum CodingKeys: String, CodingKey
    {
        case numTabs = "numTabs"
        case tabLayout = "tabLayout"
        case tabsInfo = "tabs"
        case items = "items"
    }
}
struct Stash
{
    let numTab: Int
    var tabLayout : [[String:TabLayout]?]
    var tabsInfo : [TabsInfo]
    var itemsArray : [[Item]?]
    
}
struct TabsInfo: Codable, Identifiable{
    let n: String
    let i: Int
    let id, type: String
    let hidden, selected: Bool
    let colour: tabsColour
    let srcL, srcC, srcR: String
}
struct TabLayout: Codable {
    let x, y: Double
    let w, h: Int
    let hidden: Bool?
}
