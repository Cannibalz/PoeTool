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
    @Published var tabIndex = Int(0)
    @Published var stash: Stash?
    func stashInit(leagueName: String)
    {
        PoEData.shared.getStash(leagueName: leagueName, tabIndex: 0, needTabsInfo: 1)
        { parserStash in
            var initTabsLayout = Array(repeating: [String:TabLayout](), count: parserStash.numTabs)
            var initItemsArray = Array(repeating: [Item](), count: parserStash.numTabs)
            // self.stash.append(stash)
            initTabsLayout[0] = parserStash.tabLayout!
            initItemsArray[0] = parserStash.items
            self.stash = Stash(numTab: parserStash.numTabs, tabLayout: initTabsLayout, tabsInfo: parserStash.tabsInfo, itemsArray: initItemsArray)
        }
    }

    func stashPerCellView(i: Int, cellSize: CGFloat, actived: Binding<UUID>, isShowing: Binding<Bool>) -> ItemView
    {
        print(stash?.itemsArray[tabIndex]!.indices)
//        if let item = stash?.itemsArray[tabIndex]![i]
//        {
            let returnView = ItemView(item: (stash?.itemsArray[tabIndex]![i])!, cellSize: cellSize, actived: actived, isShowing: isShowing, offset: CGSize(width: stash?.tabLayout[tabIndex]!["\(stash?.itemsArray[tabIndex]?[i].x as! Int)"]?.x ?? 0, height: stash?.tabLayout[tabIndex]!["\(stash?.itemsArray[tabIndex]?[i].x as! Int)"]?.y ?? 0))
//        }
        return returnView
    }

    func toggleToolTipView(_ geometry: GeometryProxy, _ preferences: [itemPreferenceData], activeIdx: UUID) -> some View
    {
        let p = preferences.first(where: { $0.item.uuID == activeIdx })
        let aTopLeading = p?.topLeading
        var x = p?.x
        var y = p?.y
        let topLeading = aTopLeading != nil ? geometry[aTopLeading!] : .zero
        if x! + 365 > geometry.size.width
        {
            x = geometry.size.width - 365
        }
        let iTTV = itemToolTipView(item: p!.item).offset(x: /* topLeading.x + */ x ?? Screen.Width + 30, y: y ?? 0 /* + (y ?? 640) */ )
        return iTTV
    }
}
