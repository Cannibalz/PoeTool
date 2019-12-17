//
// Created by 高梵 on 2019/10/14.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Foundation
struct CharacterInfo : Codable,Identifiable
{
    var id = UUID()
    var name : String = ""
    var league : String = ""
    var className : String = ""
    var level : Int = 0
    private enum CodingKeys : String, CodingKey {
        case name = "name", league, className = "class", level
    }
}


struct CharacterDetail: Codable {
    let items: [Item]
    let character: CharacterInfo

    enum CodingKeys: String, CodingKey {
        case items = "items"
        case character = "character"
    }
}
struct Item: Codable,Identifiable {
    let uuID = UUID()
    let verified: Bool
    var w: Int
    var h: Int
    let ilvl: Int
    let icon: String
    let id: String
    let sockets: [Socket]?
    let name: String
    let typeLine: String
    let identified: Bool
    let properties: [Property]?
    let requirements: [Property]?
    let explicitMods: [String]?
    let flavourText: [String]?
    let frameType: Int
    var x: Int
    var y: Int
    let inventoryID: String
    let socketedItems: [SocketedItem]?
    let descrText: String?
    let utilityMods: [String]?
    let shaper: Bool?
    let stackSize : Int?
    let maxStackSize: Int?
    let implicitMods: [String]?
    let corrupted: Bool?
    let enchantMods: [String]?
    let craftedMods: [String]?

    enum CodingKeys: String, CodingKey {
        case verified = "verified"
        case w = "w"
        case h = "h"
        case ilvl = "ilvl"
        case icon = "icon"
        case id = "id"
        case sockets = "sockets"
        case name = "name"
        case typeLine = "typeLine"
        case identified = "identified"
        case properties = "properties"
        case requirements = "requirements"
        case explicitMods = "explicitMods"
        case flavourText = "flavourText"
        case frameType = "frameType"
        case x = "x"
        case y = "y"
        case inventoryID = "inventoryId"
        case socketedItems = "socketedItems"
        case descrText = "descrText"
        case utilityMods = "utilityMods"
        case shaper = "shaper"
        case implicitMods = "implicitMods"
        case corrupted = "corrupted"
        case enchantMods = "enchantMods"
        case craftedMods = "craftedMods"
        case stackSize = "stackSize"
        case maxStackSize = "maxStackSize"
    }
}

// MARK: - Property
struct Property: Codable {
    let name: String
    let values: [[Value]]
    let displayMode: Int
    let type: Int?
    let progress: Double?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case values = "values"
        case displayMode = "displayMode"
        case type = "type"
        case progress = "progress"
    }
}

enum Value: Codable {
    
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Value.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Value"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - SocketedItem
struct SocketedItem: Codable {
    let verified: Bool
    let w: Int
    let h: Int
    let ilvl: Int
    let icon: String
    let support: Bool?
    let id: String
    let name: String
    let typeLine: String
    let identified: Bool
    let properties: [Property]
    let requirements: [Property]?
    let secDescrText: String?
    let explicitMods: [String]?
    let descrText: String
    let frameType: Int
    let socket: Int
    let colour: Colour
    let additionalProperties: [Property]?
    let nextLevelRequirements: [Property]?
    let corrupted: Bool?
    let hybrid: Hybrid?

    enum CodingKeys: String, CodingKey {
        case verified = "verified"
        case w = "w"
        case h = "h"
        case ilvl = "ilvl"
        case icon = "icon"
        case support = "support"
        case id = "id"
        case name = "name"
        case typeLine = "typeLine"
        case identified = "identified"
        case properties = "properties"
        case requirements = "requirements"
        case secDescrText = "secDescrText"
        case explicitMods = "explicitMods"
        case descrText = "descrText"
        case frameType = "frameType"
        case socket = "socket"
        case colour = "colour"
        case additionalProperties = "additionalProperties"
        case nextLevelRequirements = "nextLevelRequirements"
        case corrupted = "corrupted"
        case hybrid = "hybrid"
    }
}

enum Colour: String, Codable {
    case d = "D"
    case i = "I"
    case s = "S"
    case a = "A"
    case g = "G"
}
struct tabsColour : Codable
{
    let r, g, b : Int
}
// MARK: - Hybrid
struct Hybrid: Codable {
    let isVaalGem: Bool
    let baseTypeName: String
    let properties: [Property]
    let explicitMods: [String]
    let secDescrText: String

    enum CodingKeys: String, CodingKey {
        case isVaalGem = "isVaalGem"
        case baseTypeName = "baseTypeName"
        case properties = "properties"
        case explicitMods = "explicitMods"
        case secDescrText = "secDescrText"
        
    }
}

// MARK: - Socket
struct Socket: Codable {
    let group: Int
    let attr: Colour
    let sColour: SColour

    enum CodingKeys: String, CodingKey {
        case group = "group"
        case attr = "attr"
        case sColour = "sColour"
    }
}

enum SColour: String, Codable {
    case b = "B"
    case g = "G"
    case r = "R"
    case a = "A"
    case w = "W"
}
enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason):
            return reason
        }
    }
}
