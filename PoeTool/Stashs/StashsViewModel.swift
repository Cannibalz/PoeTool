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
    @Published var stashs = [Stash]()
    func getStashs(leagueName:String)
    {
        PoEData.shared.getStash(leagueName: leagueName)
        { stash in
            self.stashs.append(stash)
            print(self.stashs.count)
        }
    }
}
