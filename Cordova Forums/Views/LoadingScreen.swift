//
//  LoadingScreen.swift
//  Cordova Forums
//
//  Created by Quentin Wright on 10/15/20.
//

import SwiftUI

struct LoadingScreen: View {
    @State var isRunning = false
    
    var body: some View {
        VStack {
            Text("CF")
                .font(.system(size: 175))
                .bold()
                
            ActivityIndicator(isAnimating: .constant(true), style: .large)
            
            Text("Loading posts")
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
            .previewLayout(.device)
    }
}
