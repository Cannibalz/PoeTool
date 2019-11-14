//
//  ToolTipView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/12.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
import Combine



struct itemToolTipView: View
{
    let item : Item
    var body: some View
    {
        VStack
        {
            VStack
            {
                Text(item.name)
                Text(item.typeLine)
            }.foregroundColor(Color.frameTypeColor(item.frameType))
            Divider().foregroundColor(Color("GridColor")).colorInvert()
            ForEach(item.explicitMods?.indices ?? 0..<0)
            { i in
                Text(self.item.explicitMods![i]).foregroundColor(Color.blue)
            }.font(.system(size: 16))
            
        }.foregroundColor(Color("GridColor")).frame(width: 350, alignment: .center)
    }
}
