//
//  Post.swift
//  Cordova Forums
//
//  Created by Quentin Wright on 9/15/20.
//

import Foundation

struct ParentPost: Codable, Hashable, Identifiable {
    var id: String
    var author: String
    var subject: String
    var content: String
    var views: UInt32
    var parent: String? = nil
    var children: [String] = []
}

struct ChildPost: Codable, Hashable, Identifiable {
    var id: String
    var author: String
    var content: String
    var parent: String
}

struct APIBoardPostsResponse: Decodable {
    var error: Optional<[String : String]>
    var data: [ParentPost]?
}

struct APIChildResponse: Decodable {
    var error: Optional<[String: String]>
    var data: ChildPost?
}

struct APIChildrenResponse: Decodable {
    var error: Optional<[String : String]>
    var data: [ChildPost]?
}

struct APIPostResponse: Decodable {
    var error: Optional<[String : String]>
    var data: ParentPost?
}
