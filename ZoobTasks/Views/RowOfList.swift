//
//  RowOfList.swift
//  ZoobiTask
//
//  Created by Theappmedia on 2/10/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RowOfList: View {
    let item:Result
    var body: some View {
        HStack{
            let address = item.location.city+" "+item.location.state
            WebImage(url: URL(string: item.picture.medium))
                .resizable()
                .frame(width: Constants.height*0.13, height: Constants.height*0.13)
                .cornerRadius(50)
            VStack(alignment:.leading){
                Text("First Name: "+item.name.first)
                Text("Last Name: "+item.name.last)
                Text("Email: "+item.email)
                Text("Gender: "+item.gender.rawValue)
                Text("Address: "+address+" "+item.location.city)
            }
        }
    }
}
