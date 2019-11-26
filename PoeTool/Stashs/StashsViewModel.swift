//
//  StashViewModel.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/21.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation

class StashsViewModel : ObservableObject
{
    @Published var tabsIndex = Int(0)
    @Published var stashs = [Stash]()
    @Published var tabs : [Tab] = [Tab]()
    func stashInit(leagueName:String)
    {
        PoEData.shared.getStash(leagueName: leagueName, tabIndex: 0, needTabsInfo: 1)
        { stash in
            self.stashs.append(stash)
            self.tabs = stash.tabs
            print(self.tabs[0].type)
        }
    }
}
