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
    @ObservedObject var viewModel = StashsViewModel()
    var body: some View
    {
        VStack
        {
            if self.viewModel.stashs.count > 0
            {
                ForEach(0 ..< viewModel.stashs[0].items.count)
                { number in
                    Text(self.viewModel.stashs[0].items[number].typeLine)
//                    ZStack(alignment: .topLeading)
//                    {
//                    gridBackgroundView(cellProperty:itemCategory.seqCases[number].rawValue)
//                        ForEach(self.viewModel.catagoryItems[number])
//                        { item in
//                            itemView(item: item, cellSize: itemCategory.seqCases[number].rawValue.cellSize, actived: self.$activeIdx, isShowing: self.$showDetail)
//                        }
//                    }
//                    .frame(width: itemCategory.seqCases[number].rawValue.cellSize * itemCategory.seqCases[number].rawValue.w, height: itemCategory.seqCases[number].rawValue.cellSize * itemCategory.seqCases[number].rawValue.h)
                }
            }
        }
        .onAppear
        {
            self.viewModel.getStashs(leagueName: self.leagueName)
        }
    }
    
}
