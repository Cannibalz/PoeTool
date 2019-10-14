//
//  ContentView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/13.
//  Copyright © 2019 KaFn. All rights reserved.
//

import SwiftUI
struct characterInfo : Codable
{
    var name : String
    var league : String
    var className : String
    var level : Int
    private enum CodingKeys : String, CodingKey {
        case name, league, className = "class", level
    }
}
struct LogInView: View {
    @State private var accName = "niuwencong1"
    @State private var POESSID = "f2b5f9a200793c5b0f33ad660f8b31a8"
    var body: some View {
        VStack
        {
            TextField("Account Name",text: $accName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("POESSID",text: $POESSID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            Button(action: {
                LogIn(accName: self.accName, POESSID: self.POESSID)
                { charactersInfo in
                    print(charactersInfo.count)
                    print(charactersInfo)
                
                }
            })
            {
                Text("Log In")
            }

        }
    }
}
func LogIn(accName:String, POESSID:String, completion:@escaping ([characterInfo])->())
{
    let session = URLSession(configuration: .default)
    let urlStirng = URL(string: "https://www.pathofexile.com/character-window/get-characters?accountName=\(accName)")
    let urlReq = URLRequest(url: urlStirng!)
    let decoder = JSONDecoder()
    let task = session.dataTask(with: urlReq)
    { (data, responds, error) in
        if let data = data
        {
            do
            {
                let charactersInfo = try decoder.decode([characterInfo].self, from: data)
                return completion(charactersInfo)
            }
            catch
            {
                print(error)
            }
        }
    }.resume()
}
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
