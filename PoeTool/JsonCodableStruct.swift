//
// Created by 高梵 on 2019/10/14.
// Copyright (c) 2019 KaFn. All rights reserved.
//

import Foundation
class CharacterInfo : Codable,Identifiable
{
    var id : String = ""
    var league : String = ""
    var className : String = ""
    var level : Int = 0
    private enum CodingKeys : String, CodingKey {
        case id = "name", league, className = "class", level
    }
    public init(id:String, league:String, className:String, level:Int)
    {
        self.id = id
        self.league = league
        self.className = className
        self.level = level
    }
}


struct AccountInfo : Codable
{
    static let shared = AccountInfo()
    var characters : [CharacterInfo] = [CharacterInfo]()
    var accountName : String = ""
    var leagues = Array<String>()
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
