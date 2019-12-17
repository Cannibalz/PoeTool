//
//  ToolTipViewModel.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/12.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class ToolTipViewModel: ObservableObject
{
    var viewY = CGFloat(0)
    var viewMinX = CGFloat(0)
    var viewMaxX = CGFloat(0)
    @Published var yOffset: CGFloat?
    @Published var xOffset: CGFloat?
    var needToOffset = true
    func readSize(geoProxy: GeometryProxy) -> some View
    {
        if needToOffset
        {
            viewY = geoProxy.frame(in: .global).maxY
            viewMaxX = geoProxy.frame(in: .global).maxX
            viewMinX = geoProxy.frame(in: .global).minX
            if viewY > Screen.Height
            {
                yOffset = Screen.Height - viewY
            }
            else
            {
                yOffset = nil
            }
            if viewMinX < 0
            {
                xOffset = (0 - viewMinX)
            }
            else if viewMaxX > Screen.Width
            {
                xOffset = Screen.Width - viewMaxX
            }
            else
            {
                xOffset = nil
            }
            needToOffset = false
        }
        return Color.black.opacity(0.7)
    }

    func propText(prop: Property) -> Text
    {
        var valueString = ""
        var name = prop.name.replacingOccurrences(of: "<unmet>", with: "")
        for i in 0 ..< prop.values.count
        {
            let value = prop.values[i][0]
            var tempString = ""
            switch value
            {
            case let .integer(int):
                tempString = "\(int)"
            case let .string(str):
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

    func reqsText(reqs: [Property]) -> Text
    {
        var reqsString = "Requires "
        for i in 0 ..< reqs.count
        {
            for j in 0 ..< reqs[i].values.count
            {
                switch reqs[i].values[j][0]
                {
                case let .string(str):
                    reqsString += str
                case let .integer(int):
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

    func socketItem(_ socketedItem: [SocketedItem], itemSockets: [Socket]) -> some View
    {
        var groupArray: [String]? = Array(repeating: "", count: 6)
        var explicitModsArray: [String]? = [""]
        for var item in socketedItem
        {
            var levelString = ""
            if item.properties[0].name != "Abyss"
            {
                switch item.properties[1].values[0][0]
                {
                case let .string(str):
                    levelString = "(\(str))"
                case let .integer(int):
                    levelString = "(\(int))"
                }
                
            }
            else if item.properties[0].name == "Abyss"
            {
                explicitModsArray = item.explicitMods
            }
            if groupArray?[itemSockets[item.socket].group] == ""
            {
                groupArray?[itemSockets[item.socket].group] += "・\(item.typeLine)\(levelString)"
            }
            else
            {
                groupArray?[itemSockets[item.socket].group] += "-\(item.typeLine)\(levelString)"
            }
        }

        var returnView: some View
        {
            VStack
            {
                ForEach(groupArray?.indices ?? 0 ..< 0)
                { i in
                    if groupArray?[i] != ""
                    {
                        Text(groupArray![i]).font(.system(size: 12)).frame(alignment: .topLeading)
                    }
                }
                ForEach(explicitModsArray?.indices ?? 0 ..< 0)
                { i in
                    Text(explicitModsArray?[i] ?? "").font(.system(size: 12)).frame(alignment: .topLeading)
                }
            }
        }
        return returnView
    }

    func coloredDivider(_ frameType: Int) -> some View
    {
        return Divider().background(Color.frameTypeColor(frameType))
    }
}
