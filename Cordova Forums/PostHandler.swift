//
//  PostHandler.swift
//  Cordova Forums
//
//  Created by Quentin Wright on 9/15/20.
//

import Foundation
import SwiftUI

let base = URL(string: "https://api.cordovachat.org")!

class PostHandler: ObservableObject {
    @Published var children = [String : [ChildPost]]()
    @Published var posts = [String: [ParentPost]]()
    @Published var ready = false
    
    private let thread = DispatchQueue(label: "com.cordova-forums.posts", qos: .userInitiated)
    private var loaded = 0
    
    init() {
        Timer(timeInterval: 30, repeats: true, block: { _ in
            let boards = ["b", "s", "g", "t"]
            for board in boards {
                self.fetchPosts(board: board)
            }
        }).fire()
    }
    
    private func fetchPosts(board: String) {
        self.thread.sync {
            let url = URL(string: "/boards/\(board)/posts", relativeTo: base)!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5.0)
            print("Trying: \(board)")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { print("Data invalid for \(board)"); return }
                let posts = try! JSONDecoder().decode(APIBoardPostsResponse.self, from: data) // else { print("Error occurred"); return }

                DispatchQueue.main.async {
                    self.posts[board] = posts.data!
                    for post in posts.data! { self.children[post.id] = [] }
                    self.loaded += 1

                    print("[PostHandler] /\(board)/ ready")
                    if self.loaded == 4 { self.ready = true }
                }
            }.resume()
        }
    }
    
    public func fetchChildren(board: String, parent: String) {
        self.thread.sync {
            let url = URL(string: "/boards/\(board)/posts/\(parent)/replies", relativeTo: base)!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { print("Data invalid for \(parent)/replies"); return }
                guard let posts = try? JSONDecoder().decode(APIChildrenResponse.self, from: data) else { print("Error occurred"); return }
                
                DispatchQueue.main.async {
                    print("Children fetched, found \(posts.data!.count)")
                    for child in posts.data! {
                        if !self.children[child.parent]!.contains(where: { $0.id == child.id }) {
                            self.children[child.parent]!.append(child)
                        }
                    }
                }
            }.resume()
        }
    }
    
    public func new(board: String, subject: String, content: String, cb: @escaping (String?) -> Void) throws -> Void {
        try self.thread.sync {
            let body = ["subject": subject, "content": content]
            let request = try self.makeRequest(board: board, body: body)
            print("Making request to: \(request.url?.absoluteString ?? "Error")")
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if error != nil { cb(error!.localizedDescription) }
                guard let data = data else { return cb("empty response") }
                guard let post = try? JSONDecoder().decode(APIPostResponse.self, from: data) else { return cb("invalid json") }
                if post.error != nil { return cb(post.error!["message"]) }
                if post.data == nil { return cb("missing post") }
                
                DispatchQueue.main.async {
                    self.posts[board]!.append(post.data!)
                    self.children[post.data!.id] = []
                    cb(nil)
                }
            }.resume()
        }
    }
    
    public func new(board: String, parent: String, content: String, cb: @escaping (String?) -> Void) throws -> Void {
        try self.thread.sync {
            let body = ["content": content]
            let request = try self.makeRequest(board: board, body: body, suffix: "/\(parent)/replies")
            print("Making request to: \(request.url?.absoluteString ?? "Error")")
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if error != nil { cb(error!.localizedDescription) }
                guard let data = data else { return cb("empty response") }
                let post = try! JSONDecoder().decode(APIChildResponse.self, from: data) // else { return cb("invalid json") }
                if post.error != nil { return cb(post.error!["message"]) }
                if post.data == nil { return cb("missing post") }
                
                DispatchQueue.main.async {
                    self.children[parent]!.append(post.data!)
                    self.objectWillChange.send()
                    cb(nil)
                }
            }.resume()
        }
    }
    
    private func makeRequest<T : Encodable>(board: String, body: T, suffix: String = "") throws -> URLRequest {
        let url = URL(string: "https://api.cordovachat.org/boards/\(board)/posts\(suffix)")!
        let body = try JSONEncoder().encode(body)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = body
        return request
    }
}
