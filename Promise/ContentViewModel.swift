//
//  ContentViewModel.swift
//  Promise
//
//  Created by Gihyun Kim on 2020/03/14.
//  Copyright © 2020 wimes. All rights reserved.
//

import Foundation

class ContentViewModel: ObservableObject{
    let apiClient: APIClient = APIClient()
    
    var dict: [String:Any] = [String:Any]()
}

extension ContentViewModel{
    
    func request(){
        print("request")
        let url: URL = URL(string: "\(Config.baseURL)/get")!
        self.apiClient.get(url: url)
            .onSuccess { data in
                if let jsonString = String(data: data, encoding: .utf8){
                    if let dict = jsonStringToDictionary(jsonString: jsonString){
                        print(dict)
                        self.dict = dict
                        print(self.dict)
                        //doSomething
                    }
                }
        }
        .onFailure { error in
            print("wimesApp: \(error.localizedDescription)")
        }
    }
}
