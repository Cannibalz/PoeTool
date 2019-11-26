//
//  StashsJSON.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/21.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation

struct Stash: Codable {
    let numTabs: Int
    let tabLayout : [String: TabLayout]?
    let tabs: [Tab]
    let items: [Item]
}

struct Tab: Codable, Identifiable{
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
