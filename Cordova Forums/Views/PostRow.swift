//
//  PostRow.swift
//  Cordova Forums
//
//  Created by Quentin Wright on 9/25/20.
//

import SwiftUI

struct PostRow: View {
    var post: ParentPost
    
    var body: some View {
        HStack {
            Text(post.subject)
                .bold()
                .lineLimit(1)

            Spacer()
            
            Group {
                Text(String(post.views))
                Image(systemName: "eye")

                Text(String(post.children.count))
                Image(systemName: "quote.bubble")
            }.frame(alignment: .trailing)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

let post = ParentPost(
    id: "11763228136850",
    author: "64174118724248",
    subject: "new post title",
    content: "post content aslkjdasds",
    views: 10,
    parent: nil,
    children: ["82115334167750", "53514286405633", "63531633271863"]
)

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        PostRow(post: post).previewLayout(.sizeThatFits)
    }
}
