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
    var leagues = Array<String>()
}

struct LogInView: View {
    @State private var accName = "niuwencong1"
    @State private var POESSID = "f2b5f9a200793c5b0f33ad660f8b31a8"
    @State private var segue : Int? = 0
    @State var accountInfo : AccountInfo = AccountInfo()
    
    @ObservedObject var viewModel = LoginViewModel()
    
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
                    self.viewModel.login
                    {
                        accountInfo in
                        self.accountInfo = accountInfo
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
