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
    var leagueName: String
    @ObservedObject var viewModel = StashsViewModel()
    var cellSize = CGFloat(30.127)
    var currencyTabWidth = CGFloat(575)
    var body: some View
    {
        GeometryReader
        { _ in
            ZStack(alignment: .center)
            {
                if self.viewModel.stashs.count > 0
                {
                    ForEach(0 ..< self.viewModel.stashs[0].items.count)
                    { i in
                        URLImage(URL(string: self.viewModel.stashs[0].items[i].icon)!, content: { $0.image.resizable().aspectRatio(contentMode: .fit).clipped() })
                            .border(Color.white, width: 1)
                            .offset(x: CGFloat(self.viewModel.stashs[0].currencyLayout[String(self.viewModel.stashs[0].items[i].x)]!.x
                            ), y: CGFloat(self.viewModel.stashs[0].currencyLayout[String(self.viewModel.stashs[0].items[i].x)]!.y
                            ))
                            .frame(width: CGFloat(self.viewModel.stashs[0].items[i].w) * self.cellSize, height: CGFloat(self.viewModel.stashs[0].items[i].h) * self.cellSize)
                    }
                }
            }
            .frame(width: 575, height: 575, alignment: .topLeading)
            .scaleEffect(Screen.Width / self.currencyTabWidth)
        }

            .onAppear
        {
            self.viewModel.getStashs(leagueName: self.leagueName)
        }
    }
}
