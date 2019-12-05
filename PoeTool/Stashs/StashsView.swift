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
    var cellSize = CGFloat(37.9619)
    var currencyTabWidth = CGFloat(569)
    var scaleCoefficient: CGFloat = 1
    @State var showDetail = true
    @State var activeIdx: UUID = UUID()
    var body: some View
    {
        VStack(alignment: .center)
        {
            if (self.viewModel.stash?.numTab ?? 0) > 0
            {
                stashTabsPicker(viewModel: viewModel)
                ZStack
                {
                    ZStack
                    {
                        ForEach(0..<(self.viewModel.stash!.itemsArray[self.viewModel.tabIndex]?.count ?? 0), id:\.hashValue)// ?? 0 ..< 0)
                        { i in
                            self.viewModel.stashPerCellView(i: i, cellSize: self.cellSize, actived: self.$activeIdx, isShowing: self.$showDetail)
                        }
                    }
                }
                .frame(width: currencyTabWidth, height: currencyTabWidth, alignment: .topLeading)
                //.background(Image(self.viewModel.stash!.tabsInfo[self.viewModel.tabIndex].type))
                .scaleEffect(Screen.Width / self.currencyTabWidth)
                .padding(.top, -100)
            }
            else
            {
                EmptyView()
            }
        }
        .overlayPreferenceValue(itemPreferenceKey.self)
        { preferences in
            GeometryReader
            { geometry in
                if !self.showDetail
                {
                    self.viewModel.toggleToolTipView(geometry, preferences, activeIdx: self.activeIdx)
                }
            }
        }
        .onTapGesture
        {
            if !self.showDetail
            {
                self.showDetail = true
            }
        }
        .onAppear
        {
            self.viewModel.stashInit(leagueName: self.leagueName)
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
            if viewModel.stash?.numTab ?? 0 > 0
            {
                HStack
                {
                    ForEach(0 ..< viewModel.stash!.tabsInfo.count)
                    { i in

                        Button(action:
                            {
                                self.viewModel.stashTabCheck(tabIndex: i)
                            },
                            label:
                            {
                                Text(self.viewModel.stash!.tabsInfo[i].n)
                                    .frame(minWidth: 30)
                                    .foregroundColor(Color(red: 1.00, green: 0.75, blue: 0.47))
                                    .background(Color(red: 124 / 255, green: 84 / 255, blue: 54 / 255))
                                    .cornerRadius(10)

                        })
                    }
                }
            }
        }.frame(width:Screen.Width, height: 50)
    }
}
