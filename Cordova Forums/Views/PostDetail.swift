//
//  PostDetail.swift
//  Cordova Forums
//
//  Created by Quentin Wright on 9/25/20.
//

import SwiftUI

struct PostDetail: View {
    @EnvironmentObject var handler: PostHandler
    @State var content = ""
    @State var replies: [ChildPost] = []
    @State var replying = false
    let board: String
    let post: ParentPost
    
    func postLine(post: ChildPost) -> some View {
        return Group {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 350, height: 0.3)
        
            VStack {
                Text(verbatim: post.id).bold()
                Text(post.content)
            }.frame(maxWidth: .infinity)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text(verbatim: "/\(self.board)/\(post.id)")
                    .bold()
                    .font(.title2)
                Text(post.subject).bold().font(.title)
                Text(verbatim: post.author).foregroundColor(.gray)
            
                Spacer()
            
                Text(verbatim: post.content)
            }.frame(height: 150)
            
            Divider()
            
            VStack(spacing: 15) {
                Spacer()
                
                HStack {
                    Spacer()

                    if self.replying {
                        TextField("Reply", text: self.$content)
                        Button(action: {
                            if self.content.count == 0 { return }
                            try! self.handler.new(board: self.board, parent: self.post.id, content: self.content, cb: { error in
                                if error != nil { print(error!) }
                                self.replying = false
                            })
                        }) {
                            Text("Submit")
                        }
                    } else {
                        Image(systemName: "plus.circle")
                        Text("Reply to post")
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 35)
                .onTapGesture {
                    self.replying = true
                }
                
                    
                ForEach(self.handler.children[self.post.id]!) { child in
                    self.postLine(post: child)
                }
                
                Spacer()
            }
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            self.handler.fetchChildren(board: self.board, parent: self.post.id)
        }
    }
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetail(board: "b", post: post)
    }
}
