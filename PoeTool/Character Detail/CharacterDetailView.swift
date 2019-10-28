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
        List{
            
        
        VStack
        {
            EquipmentlView()
            ZStack
            {
                VStack(spacing:34)
                {
                    ForEach(0..<3){_ in Divider()}
                }
                HStack(spacing:34)
                {
                    ForEach(0..<6){_ in Divider()}
                }
            }.frame(width: 170, height: 68)
            ZStack
            {
                VStack(spacing:30)
                {
                    ForEach(0..<6){_ in Divider()}
                }
                HStack(spacing:30)
                {
                    ForEach(0..<13){_ in Divider()}
                }
            }.frame(width:30*12,height: 30*5)
            
            }
        
        //.navigationBarItems(leading:Button(action: {}, label: {Text("123")}))
    .navigationBarTitle(Text(viewModel.selectCharacter.id).font(.system(size: 10)), displayMode: .inline)
        }
    }
}

#if DEBUG
struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView()
    }
}
#endif
