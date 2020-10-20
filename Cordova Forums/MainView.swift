//
//  MainView.swift
//  Cordova Forums
//
//  Created by Quentin Wright on 9/15/20.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Board(id: "b", description: "General Discussion")
                .tabItem {
                    Image(systemName: "rectangle.3.offgrid.bubble.left")
                    Text("/b/").bold()
                }
            
            Board(id: "s", description: "Jocks of the WWW")
                .tabItem {
                    Image(systemName: "person.3")
                    Text("/s/").bold()
                }
            
            Board(id: "g", description: "Last of Us 2?")
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("/g/").bold()
                }
            
            Board(id: "t", description: "sudo rm -rf /")
                .tabItem {
                    Image(systemName: "pc")
                    Text("/t/").bold()
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
        }
    }
}
