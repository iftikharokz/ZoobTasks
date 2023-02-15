//
//  ProfileView.swift
//  ZoobiTask
//
//  Created by Theappmedia on 2/10/23.
//

import SwiftUI
import SDWebImageSwiftUI
struct ProfileView: View {
    let user:Result?
    var address :String?
    @Environment(\.presentationMode) var exit
    var body: some View {
        VStack{
            let address = user!.location.city+" "+user!.location.state
                HStack{
                    Button {
                        exit.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                            .padding()
                    }
                    Spacer()
                }
                .overlay(
                    Text("Profile")
                        .fontWeight(.black)
                        .font(.title)
                )
            WebImage(url: URL(string:(user?.picture.large)!))
                    .resizable()
                    .frame(width: Constants.height*0.4, height:  Constants.height*0.4)
                    .cornerRadius(30)
            VStack(alignment:.leading){
                Text("First Name: "+user!.name.first )
                Text("Last Name: "+user!.name.last)
                Text("Email: "+user!.email)
                Text("Gender: "+user!.gender.rawValue)
                Text("Address: "+address+" "+user!.location.city)
            }
            Spacer()
        }
        .navigationBarHidden(true)
    }
}
