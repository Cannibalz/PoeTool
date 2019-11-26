//
//  StashView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/21.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import Foundation
import QGrid
import SwiftUI

struct StashsView: View
{
    var leagueName: String
    @ObservedObject var viewModel = StashsViewModel()
    var cellSize = CGFloat(30.127)
    var currencyTabWidth = CGFloat(569)
    var scaleCoefficient : CGFloat = 1
    var body: some View
    {
        VStack(alignment:.center)
        {
            if self.viewModel.stashs.count > 0
            {
                ZStack(alignment: .top)
                {
                    ForEach(0 ..< self.viewModel.stashs[0].items.count)
                    { i in
                        URLImage(URL(string: self.viewModel.stashs[0].items[i].icon)!, content: { $0.image.resizable().aspectRatio(contentMode: .fit).clipped() })
                            .offset(x: CGFloat(self.viewModel.stashs[0].tabLayout![String(self.viewModel.stashs[0].items[i].x)]!.x
                            ), y: CGFloat(self.viewModel.stashs[0].tabLayout![String(self.viewModel.stashs[0].items[i].x)]!.y
                            ))
                            .frame(width: CGFloat(self.viewModel.stashs[0].items[i].w) * self.cellSize, height: CGFloat(self.viewModel.stashs[0].items[i].h) * self.cellSize)
                    }
                }
                .frame(width: currencyTabWidth, height: currencyTabWidth, alignment: .topLeading)
                .background(Image(self.viewModel.tabs[2].type))
                //.scaleEffect(Screen.Width / self.currencyTabWidth)
                stashTabsPicker(viewModel: viewModel)
            }
            else{EmptyView()}
        }
        .onAppear
        {
            self.viewModel.getStash(leagueName: self.leagueName)
        }
    }
}

struct stashTabsPicker: View
{
    @ObservedObject var viewModel: StashsViewModel
    var body: some View
    {
        ScrollView(.horizontal)
        {
            if viewModel.stashs.count > 0
            {
                HStack
                {
                    ForEach(0 ..< viewModel.stashs[0].tabs.count)
                    { i in
                        Text(self.viewModel.stashs[0].tabs[i].n).foregroundColor(Color.white)
                            .frame(minWidth: 30)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 1))
                    }
                }
            }
        }.frame(height: 50)
    }
}
