//
//  ContentView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/13.
//  Copyright © 2019 KaFn. All rights reserved.
//

import SwiftUI

struct LogInView: View {
    @State private var accName = ""
    var body: some View {
        VStack
        {
            TextField("Account Name",text: $accName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
