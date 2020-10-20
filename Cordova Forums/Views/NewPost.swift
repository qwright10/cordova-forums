//
//  NewPost.swift
//  Cordova Forums
//
//  Created by Quentin Wright on 10/14/20.
//

import SwiftUI

struct NewPost: View {
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @EnvironmentObject var posts: PostHandler
    @State private var subject: String = ""
    @State private var content: String = ""
    let board: String
    let replyingTo: String?
    
    init(board: String, replyingTo: String? = nil) {
        self.board = board;
        self.replyingTo = replyingTo
    }
    
    var body: some View {
        VStack {
            if let parent = self.replyingTo {
                Text("/\(self.board)/\(parent)/replies")
                    .bold()
                    .font(.title2)
                    .padding()
                    .navigationBarTitle("New Reply")
            }

            if self.replyingTo == nil {
                TextField("Subject", text: $subject)
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
            }

            TextEditor(text: $content)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .font(.body)
                .foregroundColor(Color.gray)
                .lineLimit(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 0.2)
                )
                .padding(.horizontal)
                .padding(.bottom)

            Button(action: {
                if self.replyingTo == nil {
                    print("Creating new parent post")
                    try! posts.new(board: self.board, subject: self.subject, content: self.content, cb: { (error) in
                        if error != nil { return print(error!) }
                        self.presentation.wrappedValue.dismiss()
                    })
                } else {
                    try! posts.new(board: self.board, parent: self.replyingTo!, content: self.content, cb: { (error) in
                        if error != nil { return print(error!) }
                        self.presentation.wrappedValue.dismiss()
                    })
                }
            }) {
                Text(self.replyingTo == nil ? "Create Post" : "Submit Reply")
            }
        }.padding().onAppear {
            print(self.replyingTo ?? "nil")
        }
    }
}

struct NewPost_Previews: PreviewProvider {
    static var previews: some View {
        NewPost(board: "b")
        NewPost(board: "b", replyingTo: "12312313")
    }
}
