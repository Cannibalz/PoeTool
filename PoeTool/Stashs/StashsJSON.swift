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

typealias Currency = [CurrencyElement]
struct CurrencyElement: Codable {
    let id: Int
    let name: String
    let category, group: Category
    let frame: Int
    //let influences: [JSONAny]
    let stackSize: Int?
    let icon: String
    let mean, median, mode, min: Double
    let max, exalted: Double
    let total, daily, current, accepted: Int
    let change: Double
    let history: [Double?]
    let type: String?
}
enum Category: String, Codable {
    case catalyst = "catalyst"
    case currency = "currency"
    case essence = "essence"
    case fossil = "fossil"
    case incubator = "incubator"
    case influence = "influence"
    case oil = "oil"
    case piece = "piece"
    case resonator = "resonator"
    case splinter = "splinter"
    case vial = "vial"
}
