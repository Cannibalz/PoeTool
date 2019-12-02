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
    @State private var activeIdx: UUID = UUID()
    var body: some View
    {
        VStack(alignment: .center)
        {
            if self.viewModel.stashs.count > 0
            {
                stashTabsPicker(viewModel: viewModel)
                ZStack
                {
                    ZStack
                    {
                        ForEach(0 ..< self.viewModel.stashs[0].items.count)
                        { i in
                            itemView(item: self.viewModel.stashs[0].items[i], cellSize: self.cellSize, actived: self.$activeIdx, isShowing: self.$showDetail,offset:CGSize(width: CGFloat(self.viewModel.stashs[0].tabLayout![String(self.viewModel.stashs[0].items[i].x)]!.x), height: CGFloat(self.viewModel.stashs[0].tabLayout![String(self.viewModel.stashs[0].items[i].x)]!.y)))
//                                .offset(x: CGFloat(self.viewModel.stashs[0].tabLayout![String(self.viewModel.stashs[0].items[i].x)]!.x
//                                ), y: CGFloat(self.viewModel.stashs[0].tabLayout![String(self.viewModel.stashs[0].items[i].x)]!.y
//                                ))
                                //.frame(width: CGFloat(self.viewModel.stashs[0].items[i].w) * self.cellSize, height: CGFloat(self.viewModel.stashs[0].items[i].h) * self.cellSize)
                        }
                        
                    }
                    
                }
                .frame(width: currencyTabWidth, height: currencyTabWidth, alignment: .topLeading)
                .background(Image(self.viewModel.tabs[0].type))
                .scaleEffect(Screen.Width / self.currencyTabWidth)
                .padding(.top, -100)
            }
            else
            {
                EmptyView()
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
            if viewModel.stashs.count > 0
            {
                HStack
                {
                    ForEach(0 ..< viewModel.stashs[0].tabs.count)
                    { i in
                        Text(self.viewModel.stashs[0].tabs[i].n)
                            .frame(minWidth: 30)
                            .foregroundColor(Color(red: 1.00, green: 0.75, blue: 0.47))
                            .background(Color(red: 124 / 255, green: 84 / 255, blue: 54 / 255))
                            .cornerRadius(10)
                    }
                }
            }
        }.frame(height: 50)
    }
}
