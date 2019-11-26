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
    func getStash(leagueName:String)
    {
        PoEData.shared.stashInit(leagueName: leagueName)
        { stash in
            self.stashs.append(stash)
            self.tabs = stash.tabs
            print(self.tabs[0].type)
        }
    }
}
