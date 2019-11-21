//
//  StashView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/21.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
struct StashsView: View
{
    var leagueName : String
    var viewModel = StashsViewModel()
    var body: some View
    {
        VStack
        {
            Text(leagueName)
            Text("2")
        }
        .onAppear
        {
            self.viewModel.getStashs(leagueName: self.leagueName)
        }
    }
    
}
