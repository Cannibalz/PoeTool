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
            Divider().background(Color.frameTypeColor(item.frameType))
            ForEach(item.properties?.indices ?? 0..<0)
            { i in
                self.propString(prop: self.item.properties![i])
            }
            ForEach(item.explicitMods?.indices ?? 0..<0)
            { i in
                Text(self.item.explicitMods![i]).foregroundColor(Color.blue)
            }.font(.system(size: 16))
            
        }.foregroundColor(Color("GridColor")).frame(width: 350, alignment: .center)
    }
    func propString(prop:Property) -> Text
    {
        var valueString = ""
        if prop.values.count > 0
        {
            let value = prop.values[0][0]
            switch value
            {
            case .integer(let int):
                valueString = ": \(int)"
            case .string(let str):
                valueString = ": \(str)"
            }
            
        }
        return Text("\(prop.name)\(valueString)")
    }
}
