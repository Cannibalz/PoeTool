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
        GeometryReader
        { geo in
            VStack
            {
                VStack
                {
                    Text(item.name)
                    Text(item.typeLine)
                }.foregroundColor(Color.frameTypeColor(item.frameType))
                coloredDivider(self.item.frameType)
                ForEach(item.properties?.indices ?? 0..<0)
                { i in
                    self.propText(prop: self.item.properties![i])
                }
                if(item.properties?.count ?? 0 > 0)
                {
                    coloredDivider(self.item.frameType)
                }
                if(item.requirements?.count ?? 0 > 0)
                {
                    self.reqsText(reqs: self.item.requirements!)
                    coloredDivider(self.item.frameType)
                }
                ForEach(item.explicitMods?.indices ?? 0..<0)
                { i in
                    Text(self.item.explicitMods![i]).foregroundColor(Color.blue)
                }.font(.system(size: 16))
                
            }.foregroundColor(Color("GridColor")).frame(width: 350, alignment: .center)
        }
        
    }
    func propText(prop:Property) -> Text
    {
        var valueString = ""
        var name = prop.name
        for i in 0..<prop.values.count
        {
            let value = prop.values[i][0]
            var tempString = ""
            switch value
            {
            case .integer(let int):
                tempString = "\(int)"
            case .string(let str):
                tempString = "\(str)"
            }
            if name.contains("%\(i)")
            {
                name = name.replacingOccurrences(of: "%\(i)", with: tempString, options: .literal, range: nil)
            }
            else
            {
                valueString = ": \(tempString)"
            }
        }
        return Text("\(name)\(valueString)")
    }
    func reqsText(reqs:[Property])->Text
    {
        var reqsString = "Requires "
        for i in 0..<reqs.count
        {
            for j in 0..<reqs[i].values.count
            {
                switch reqs[i].values[j][0]
                {
                    case .string(let str):
                        reqsString += str
                    case .integer(let int):
                        reqsString += "\(int)"
                }
            }
            reqsString += " \(reqs[i].name)"
            if i != reqs.count - 1
            {
                reqsString += ", "
            }
            
        }
        return Text(reqsString)
    }
    func coloredDivider(_ frameType:Int)->some View
    {
        return Divider().background(Color.frameTypeColor(frameType))
    }
}
