//
//  StashViewModel.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/21.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI

class StashsViewModel: ObservableObject
{
    let tabCellSize: [String: CGFloat] = ["CurrencyStash": 37.9619, "FragmentStash": 30.127, "EssenceStash": 38.3238, "DelveStash": 42.1795]
    //Currency,Fragment在Currency中, Fossil, Essence, DivinationCard
    let priceableName : [String] = ["Currency","Fossil","Essence","DivinationCard","Incubator","Oil","Scarab","Fossil","Resonator","Prophecy"]
    @Published var tabIndex = Int(0)
    @Published var stash: Stash?
    @Published var prices : [String:Line] = [:]
    var leagueName = ""
    func stashInit(leagueName: String)
    {
        var delay : Double = 5
        PoEData.shared.getStash(leagueName: leagueName, tabIndex: 0, needTabsInfo: 1)
        { parserStash in
            var initTabsLayout = Array(repeating: [String: TabLayout](), count: parserStash.numTabs)
            var initItemsArray = Array(repeating: [Item](), count: parserStash.numTabs)
            // self.stash.append(stash)
            
            initTabsLayout[0] = parserStash.tabLayout ?? [:]
            initItemsArray[0] = parserStash.items
            self.stash = Stash(numTab: parserStash.numTabs, tabLayout: initTabsLayout, tabsInfo: parserStash.tabsInfo!, itemsArray: initItemsArray)
            self.leagueName = leagueName
            PoEData.shared.allPrice
            { Lines in
                
                self.prices.merge(Lines.toDictionary{$0.currencyTypeName ?? $0.name!}){(current, _) in current}
            }
        }
        
    }

    func loadTab(leagueName: String, tabIndex: Int)
    {
        PoEData.shared.getStash(leagueName: leagueName, tabIndex: tabIndex, needTabsInfo: 0)
        { parserStash in
            self.stash?.itemsArray[tabIndex] = parserStash.items
            if parserStash.tabLayout?.count ?? 0 > 0
            {
                self.stash?.tabLayout[tabIndex] = parserStash.tabLayout
            }
            self.tabIndex = tabIndex
        }
    }

    func divinationCardCell(item: Item) -> some View
    {
        var returnView: some View
        {
            URLImage(URL(string: "https://web.poecdn.com/image/divination-card/\(item.artFilename!).png")!, content: { $0.image.resizable().aspectRatio(contentMode: .fit).clipped() })
                .overlay(Text(item.typeLine + "\n" + item.properties![0].values[0][0].str()).font(.system(size: 12)).background(Color.alphaBackground()), alignment: .topLeading)
                .overlay(Text(ItemView.totalPriceStr(price: prices[item.typeLine]?.chaosValue ?? 0, stackSize: item.stackSize ?? 1)).font(.system(size: 14)).background(Color.alphaBackground()), alignment: .bottomTrailing)
        }
        return returnView
    }

    func stashPerCellView(i: Int, actived: Binding<UUID>, isShowing: Binding<Bool>) -> AnyView
    {
        var returnView = AnyView(EmptyView())
        var chaosPrice : Double = 0
        if prices[(stash?.itemsArray[tabIndex]![i].typeLine ?? "")]?.chaosEquivalent != nil
        {
            chaosPrice = (prices[(stash?.itemsArray[tabIndex]![i].typeLine ?? "")]?.chaosEquivalent)!
        }
        else if prices[(stash?.itemsArray[tabIndex]![i].typeLine ?? "")]?.chaosValue != nil
        {
            chaosPrice = (prices[(stash?.itemsArray[tabIndex]![i].typeLine ?? "")]?.chaosValue)!
        }
        else
        {
            chaosPrice = 0
        }
        if tabCellSize.keys.contains(stash?.tabsInfo[tabIndex].type ?? "")
        {
            
                returnView = AnyView(ItemView(item: (stash?.itemsArray[tabIndex]![i])!, price: chaosPrice, cellSize: tabCellSize[stash?.tabsInfo[tabIndex].type ?? ""] ?? 0, actived: actived, isShowing: isShowing, offset: CGSize(width: stash?.tabLayout[tabIndex]!["\(stash?.itemsArray[tabIndex]?[i].x as! Int)"]?.x ?? 0, height: stash?.tabLayout[tabIndex]!["\(stash?.itemsArray[tabIndex]?[i].x as! Int)"]?.y ?? 0)))
        }
        else if stash?.tabsInfo[tabIndex].type == "QuadStash"
        {
            returnView = AnyView(ItemView(item: (stash?.itemsArray[tabIndex]![i])!,price: chaosPrice, cellSize: 569 / 24, actived: actived, isShowing: isShowing))
        }
        else if stash?.tabsInfo[tabIndex].type == "DivinationCardStash"
        {
        }
        else
        {
            returnView = AnyView(ItemView(item: (stash?.itemsArray[tabIndex]![i])!,price: chaosPrice, cellSize: 569 / 12, actived: actived, isShowing: isShowing))
        }
        return returnView
    }

    func stashTabCheck(tabIndex: Int)
    {
        if stash?.itemsArray[tabIndex]?.count == 0
        {
            loadTab(leagueName: leagueName, tabIndex: tabIndex)
        }
        else if stash?.tabsInfo[tabIndex].type == "MapStash"
        {
        }
        else
        {
            self.tabIndex = tabIndex
        }
    }

    func toggleToolTipView(_ geometry: GeometryProxy, _ preferences: [itemPreferenceData], activeIdx: UUID) -> some View
    {
        if let p = preferences.first(where: { $0.item.uuID == activeIdx })
        {
            let x = p.x
            let y = p.y
            let iTTV = itemToolTipView(item: p.item).offset(x: x, y: y)
            return AnyView(iTTV)
        }
        else
        {
            return AnyView(EmptyView())
        }
    }

    func highlightBorder(_ i: Int) -> Color
    {
        if i == tabIndex
        {
            return Color.yellow
        }
        else
        {
            return Color(.sRGB, white: 0, opacity: 0)
        }
    }
}
