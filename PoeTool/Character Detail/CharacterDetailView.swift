//
//  CharacterDetail.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/23.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct CharacterDetailView:View
{
    @ObservedObject var viewModel = CharacterDetailViewModel()
    //@ObservedObject var viewModel = CharacterDetailViewModel(Detail:character)
    var body: some View
    {
                VStack
                {
                    ZStack
                    {
                        VStack(spacing:23)
                        {
                            ForEach(0..<21){_ in Divider()}
                        }
                        HStack(spacing:23)
                        {
                            ForEach(0..<15){_ in Divider()}
                        }
                        VStack
                        {
                            Text(viewModel.selectCharacter.className)
                        }
                    }
                    .frame(width: 350.0, height: 500.0)
                }
        .padding(.top).edgesIgnoringSafeArea(.all)
        //.navigationBarItems(leading:Button(action: {}, label: {Text("123")}))
                .navigationBarTitle(Text(viewModel.selectCharacter.id).font(.system(size: 10)), displayMode: .inline)
    }
}

#if DEBUG
struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView()
    }
}
#endif
