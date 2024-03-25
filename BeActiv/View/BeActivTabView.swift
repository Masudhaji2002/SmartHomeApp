//
//  BeActivTabView.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 29.02.2024.
//


import SwiftUI

struct BeActivTabView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            SmartHomeView()
                .tag("SmartHome")
                .tabItem { Image(systemName: "house.fill") }
            
            HomeView()
                .environmentObject(manager)
                .tag("Home")
                .tabItem {
                    Image(systemName: "heart.fill")
                }
                
            ChartsView()
                .environmentObject(manager)
                .tag("Charts")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                }
            
            ProfileView()
                .tag("Content")
                .tabItem {
                    Image(systemName: "person")
                }
            
        }
    }
}

struct BeActivTabView_Previews: PreviewProvider {
    static var previews: some View {
        BeActivTabView()
            .environmentObject(HealthManager())
    }
}
