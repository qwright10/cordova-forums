//
//  Board.swift
//  Cordova Forums
//
//  Created by Quentin Wright on 9/25/20.
//

import SwiftUI

struct Board: View {
    let id: String
    let description: String
    @EnvironmentObject var handler: PostHandler
    @State var isShowing = false
    
    init(id: String, description: String) {
        self.id = id
        self.description = description
    }
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: NewPost(board: self.id)) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Create new post")
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 50)
                }
                
                ForEach(self.handler.posts[self.id]!) { post in
                    NavigationLink(destination: PostDetail(board: self.id, post: post)) {
                        PostRow(post: post)
                    }
                }
            }
            .navigationBarTitle(description)
        }
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        Board(id: "b", description: "General Discussion")
    }
}
