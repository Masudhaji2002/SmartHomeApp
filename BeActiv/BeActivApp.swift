//
//  BeActivApp.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 29.02.2024.
//

import SwiftUI
import Firebase

@main
struct BeActivApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var manager = HealthManager()
    
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            LoginView()
              .environmentObject(viewModel)
              .environmentObject(manager)
                
          // HomeView()
              // .environmentObject(manager)
                
            //ContentView()
        }
    }
}
