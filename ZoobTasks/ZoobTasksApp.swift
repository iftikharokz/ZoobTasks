//
//  ZoobTasksApp.swift
//  ZoobTasks
//
//  Created by Theappmedia on 2/15/23.
//

import SwiftUI
import GoogleMobileAds

@main
struct ZoobTasksApp: App {
    init(){
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "9036d90b0585870c2d507b01b5372e22" ]
    }
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
        }
    }

}
