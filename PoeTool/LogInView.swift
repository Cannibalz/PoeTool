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

}
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
//            Button(action: <#T##@escaping () -> Void##@escaping () -> Swift.Void#>, label: <#T##() -> Label##() -> Label#>)
        }
    }
}
func LogIn(accName:String, POESSID:String, completion: @escaping (NSArray)-> Void)
{

}
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
