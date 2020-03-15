//
//  ContentView.swift
//  Promise
//
//  Created by Gihyun Kim on 2020/03/13.
//  Copyright © 2020 wimes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        List{
            Button(action: self.request){
                Text("request")
            }
            
        }
    }
}

extension ContentView{
    
    func request(){
        self.viewModel.request()
    }
}
