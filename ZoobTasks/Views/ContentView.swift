//
//  ContentView.swift
//  ZoobiTask
//
//  Created by Theappmedia on 2/9/23.
//

import SwiftUI
import SDWebImageSwiftUI
import GoogleMobileAds
struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel = ViewModel()
    @State var results :[Result]?
    let interstitial = InterstitialAd()
    @State var  isSelected: Bool = false
    @State var nativeAdLoaded = false
    @State var showDeleteButton=false
    @State var selectedItemIndex:[Int] = []
    @State var selectedItem:Result?
    @State var showProfile = false
    var testView: some View{
        ForEach(Array(results!.enumerated()),id:\.offset) {index,item in
            HStack{
                Button{
                    selectedItem = item
                    showProfile = true
                    interstitial.adsShow()
                } label: {
                    RowOfList(item:item)
                }
                Spacer()
                Button{
                    if selectedItemIndex.contains(index){
                        selectedItemIndex.remove(at: index)
                    }else{
                        showDeleteButton = true
                        selectedItemIndex.append(index)
                    }
                }label:{
                    ZStack{
                        Rectangle()
                            .stroke()
                            .frame(width: 20, height: 20)
                        if selectedItemIndex.contains(index){
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 20, height: 20)
                        }else{
                            EmptyView()
                        }
                    }
                }
            }
            Divider()
                .frame(width: Constants.width-20, height: 2)
            if (index+1)%5==0{
                NativeAdView(adLoaded:$nativeAdLoaded)
                    .frame(width: Constants.width-40, height:nativeAdLoaded ? 100:0)
            }
        }
    }
    var body: some View {
        VStack{
            NavigationLink(destination: ProfileView(user: selectedItem),
                           isActive: $showProfile) {
                EmptyView()
            }
            HStack{
                Spacer()
                Text("Users")
                    .fontWeight(.black)
                    .font(.title)
                    .padding()
                Spacer()
            }
            .foregroundColor(Color.white)
            .background(Color.blue.opacity(0.8).ignoresSafeArea())
            ScrollView{
                if results != nil{
                    testView
                    EmptyView()
                }else{
                    ProgressView()
                }
            }
            if showDeleteButton{
                Button{
                    for i in selectedItemIndex{
                        results?.remove(at: i)
                    }
                    selectedItemIndex.removeAll()
                    showDeleteButton = false
                }label:{
                    Text("Delete")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
        }
        .foregroundColor(.black)
        .onChange(of: scenePhase) {newPhase in
            if newPhase == .active {
                interstitial.adsShow()
            } else if newPhase == .inactive {
                interstitial.adsLoad()
            } else if newPhase == .background {
                interstitial.adsLoad()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchWelcome{ model in
                results = model?.results
            }
            interstitial.adsLoad()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



