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
    var stashs = [Stash]()
    func getStashs(leagueName:String)
    {
        PoEData.shared.getStash(leagueName: leagueName)
        { stashs in
            print(stashs)
        }
    }
}
