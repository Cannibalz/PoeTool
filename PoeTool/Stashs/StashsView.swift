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

// https://poe.ninja/api/Data/GetCurrencyOverview?league=Metamorph

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
            //arrow.2.circlepath
            Divider()
            if (self.viewModel.stash?.numTab ?? 0) > 0 && self.viewModel.prices.count > 0
            {
                stashTabsPicker(viewModel: viewModel)
                
                ZStack(alignment: .topLeading)
                {
                    if self.viewModel.stash?.tabsInfo[self.viewModel.tabIndex].type == "DivinationCardStash"
                    {
                        
                        QGrid(self.viewModel.stash?.itemsArray[self.viewModel.tabIndex] ?? [], columns: 4)
                        {item in
                            self.viewModel.divinationCardCell(item: item)
                            
                        }
                    }
                    else if self.viewModel.stash?.tabsInfo[self.viewModel.tabIndex].type == "UniqueStash"
                    {
                        Text("Unique tab is not available with POE API now!")
                    }
                    else
                    {
                        ForEach(0 ..< (self.viewModel.stash!.itemsArray[self.viewModel.tabIndex]?.count ?? 0), id: \.hashValue)
                        { i in
                            self.viewModel.stashPerCellView(i: i, actived: self.$activeIdx, isShowing: self.$showDetail)
                        }
                    }
                }
                .frame(width: currencyTabWidth, height: currencyTabWidth, alignment: .topLeading)
                .border(Color(red: Double(self.viewModel.stash!.tabsInfo[self.viewModel.tabIndex].colour.r) / 255, green: Double(self.viewModel.stash!.tabsInfo[self.viewModel.tabIndex].colour.g) / 255, blue: Double(self.viewModel.stash!.tabsInfo[self.viewModel.tabIndex].colour.b) / 255), width: 2)
                .background(Image(self.viewModel.stash!.tabsInfo[self.viewModel.tabIndex].type))
                .scaleEffect(Screen.Width / self.currencyTabWidth)
                .padding(.top, -100)
                Text(String(format:"%.1f",self.viewModel.prices["Mirror Shard"]?.chaosEquivalent ?? 1))
            }
            else
            {
                EmptyView()
            }
        }
            .navigationBarItems(trailing: Button(action: {
                self.viewModel.loadTab(leagueName: self.leagueName, tabIndex: self.viewModel.tabIndex)
                }, label: {
                    Image(systemName: "arrow.2.circlepath")
            }))
        .overlayPreferenceValue(itemPreferenceKey.self)
        { preferences in
            GeometryReader
            { geometry in
                if !self.showDetail && preferences.count > 0
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
                                    .foregroundColor(Color(red: 1.00, green: 1.00 /* 0.75 */, blue: 1.00 /* 0.47 */ ))
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                                    .frame(minWidth: 30)
                                    .background(Color(red: Double(self.viewModel.stash!.tabsInfo[i].colour.r) / 255, green: Double(self.viewModel.stash!.tabsInfo[i].colour.g) / 255, blue: Double(self.viewModel.stash!.tabsInfo[i].colour.b) / 255))
                                    .border(self.viewModel.highlightBorder(i), width: 2)

                        })
                    }
                }
            }
        }.frame(width: Screen.Width, height: 50)
    }
}
