//
//  ViewModel.swift
//  ZoobiTask
//
//  Created by Theappmedia on 2/9/23.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    func fetchWelcome(completion: @escaping (Welcome?) -> Void) {
        var request = URLRequest(url: URL(string: "https://randomuser.me/api/?results=30")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
        
          guard let data = data else {
            print(String(describing: error))
            return
          }
//          print(String(data: data, encoding: .utf8)!)
            do{
                let welcome = try JSONDecoder().decode(Welcome.self, from: data)
                completion(welcome)
            }catch{
                print(error)
            }
        }.resume()
    }
    
}
