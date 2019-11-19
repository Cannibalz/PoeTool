//
//  ToolTipView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/12.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

struct itemToolTipView: View
{
    @ObservedObject var viewModel = ToolTipViewModel()
    @State var size = CGSize.zero
    let item: Item
    var body: some View
    {
        VStack
        {
            VStack
            {
                VStack
                {
                    Text(item.name)
                    Text(item.typeLine)
                }.foregroundColor(Color.frameTypeColor(item.frameType))
                viewModel.coloredDivider(self.item.frameType)
                ForEach(item.properties?.indices ?? 0 ..< 0)
                { i in
                    self.viewModel.propText(prop: self.item.properties![i])
                }
                if item.properties?.count ?? 0 > 0
                {
                    viewModel.coloredDivider(self.item.frameType)
                }
                if item.requirements?.count ?? 0 > 0
                {
                    viewModel.reqsText(reqs: self.item.requirements!)
                    viewModel.coloredDivider(self.item.frameType)
                }
                ForEach(item.explicitMods?.indices ?? 0 ..< 0)
                { i in
                    Text(self.item.explicitMods![i]).foregroundColor(Color.blue).multilineTextAlignment(.center)
                }
            }
            .offset(x: 0, y: viewModel.yOffset ?? 0)
            .foregroundColor(Color("GridColor")).frame(width: 350, alignment: .center)
            .background(
                GeometryReader
                { geoProxy in
                    self.viewModel.readSize(geoProxy: geoProxy)
                }.offset(x: 0, y: viewModel.yOffset ?? 0)
            )
        }.font(.system(size: 14))
    }
}
