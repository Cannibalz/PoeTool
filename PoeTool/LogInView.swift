//
//  ContentView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/13.
//  Copyright © 2019 KaFn. All rights reserved.
//

import SwiftUI
struct AccountInfo : Codable
{
    var characters : [CharacterInfo] = [CharacterInfo]()
    var accountName : String = ""
}
class CharacterInfo : Codable,Identifiable
{
    var id : String? = ""
    var league : String? = ""
    var className : String? = ""
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
struct LogInView: View {
    @State private var accName = "niuwencong1"
    @State private var POESSID = "f2b5f9a200793c5b0f33ad660f8b31a8"
    @State private var segue : Int? = 0
    @State var accountInfo : AccountInfo = AccountInfo(characters: [CharacterInfo](), accountName: "")
    
    
    var body: some View {
        NavigationView
        {
            VStack
            {
                NavigationLink(destination: CharacterSelectView(account:self.$accountInfo), tag: 1, selection: $segue) {
                    EmptyView()
                }
                TextField("Account Name",text: $accName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                TextField("POESSID",text: $POESSID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                Button(action: {
                    LogIn(accName: self.accName, POESSID: self.POESSID)
                    { charactersInfo in
                        self.accountInfo.characters = charactersInfo
                        self.accountInfo.accountName = self.accName
                        
                        self.segue = Int(1)
                    }
                })
                {
                    Text("Log In")
                }

            }
        }

    }
}
func LogIn(accName:String, POESSID:String, completion:@escaping ([CharacterInfo])->())
{
    let session = URLSession(configuration: .default)
    let urlString = URL(string: "https://www.pathofexile.com/character-window/get-characters?accountName=\(accName)")
    let urlReq = URLRequest(url: urlString!)
    let decoder = JSONDecoder()
    _ = session.dataTask(with: urlReq)
    { (data, responds, error) in
        if let data = data
        {
            do
            {
                let charactersInfo = try decoder.decode([CharacterInfo].self, from: data)
                return completion(charactersInfo)
            }
            catch
            {
                print(error)
            }
        }
    }.resume()
}
#if DEBUG
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
#endif
