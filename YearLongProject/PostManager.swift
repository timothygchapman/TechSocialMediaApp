//
//  PostManager.swift
//  YearLongProject
//
//  Created by Timothy Chapman on 7/10/24.
//

import Foundation

enum PostsManagerError: Error {
    case invalidURL
    case dataNotFound
    case invalidResponse
    case invalidSignIn
}

class PostsManager {
    static let shared = PostsManager()
    private(set) var posts: [Post] = []
    var myPosts: [Post] {
            guard let currentUserName = User.current?.userName else {
                return []
            }
            return posts.filter { $0.authorUserName == currentUserName }
        }
    
    func updatePost(_ id: Int, newPost: Post) {
            if let index = posts.firstIndex(where: { $0.postid == id }) {
                posts[index] = newPost
            }
        }
    
    func deletePost(postId: Int, userSecret: UUID) async throws {
        guard var urlComponents = URLComponents(string: "\(API.url)/post") else {
            print("Invalid URL when deleting post.")
            throw PostsManagerError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "userSecret", value: userSecret.uuidString),
            URLQueryItem(name: "postid", value: "\(postId)")
        ]
        
        guard let url = urlComponents.url else {
            print("Invalid URL when deleting")
            throw PostsManagerError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to delete post.")
                throw PostsManagerError.invalidResponse
            }
            
            if let index = posts.firstIndex(where: { $0.postid == postId }) {
                posts.remove(at: index)
            }
        } catch {
            print("Error occurred while deleting post: \(error)")
            throw error
        }
}
    
    func signInValidation(email: String, password: String) async throws -> User {
        guard let url = URL(string: "\(API.url)/signIn") else {
            print("Invalid Sign In URL call.")
            throw PostsManagerError.invalidSignIn
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = postData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Detailed Logging
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to sign in, received invalid response: \(response)")
                let responseString = String(data: data, encoding: .utf8) ?? "No response body."
                print("Response Body: \(responseString)")
                throw PostsManagerError.invalidResponse
            }
            
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch {
            print("Failed to encode parameters or decode response: \(error)")
            throw error
        }
    }
    
    func fetchPosts() async throws {
        guard let url = URL(string: "\(API.url)/posts") else {
            print("The API URL is incorrect")
            throw PostsManagerError.invalidURL
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let query = URLQueryItem(name: "userSecret", value: User.current?.secret.uuidString)
        components?.queryItems = [query]
        guard let updatedURL = components?.url else {
            throw PostsManagerError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: updatedURL)
        
        let posts = try JSONDecoder().decode([Post].self, from: data)
        self.posts = posts
    }
}

extension PostsManager {
    func createPost(title: String, body: String) async throws -> Post {
        let url = URL(string: "https://tech-social-media-app.fly.dev/createPost")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String : Any] = ["userSecret": User.current!.secret.uuidString, "post": ["title": title, "body": body]]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let createdPost = try JSONDecoder().decode(Post.self, from: data)
        
        posts.append(createdPost)
        
        return createdPost
    }

    func editPost(post: Post, userSecret: UUID, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = URL(string: "\(API.url)/editPost") else {
           
            print("Invalid URL when editing post.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyParameters: [String: Any] = [
            "userSecret": userSecret.uuidString,
            "post": [
                "postid": post.postid,
                "title": post.title,
                "body": post.body
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
        
                print("No data recieved when editing post.")
                return
            }
            
            do {
                let updatedPost = try JSONDecoder().decode(Post.self, from: data)
                if let index = self.posts.firstIndex(where: { $0.postid == post.postid }) {
                    self.posts[index] = updatedPost
                }
                if let index = self.myPosts.firstIndex(where: { $0.postid == post.postid }) {
                    self.updatePost(post.postid, newPost: updatedPost)
                }
                completion(.success(updatedPost))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
