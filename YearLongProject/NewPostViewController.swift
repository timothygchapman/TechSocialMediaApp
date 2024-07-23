//
//  NewPostViewController.swift
//  YearLongProject
//
//  Created by Timothy Chapman on 7/3/24.
//


import UIKit

class NewPostViewController: UIViewController, UINavigationControllerDelegate {
    
    static let url = "https://tech-social-media-app.fly.dev"

    @IBOutlet var newPostTextView: UITextView!
    @IBOutlet var createPostButton: UIButton!
    
    weak var delegate: PostCreationNotifcationDelegate?
    weak var profileDelegate: PostCreationNotifcationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createButtonPressed(_ sender: Any) {
        guard let body = newPostTextView.text, !body.isEmpty else {
            return
        }
        
        Task {
            do {
                let createdPost = try await PostsManager.shared.createPost(title: "Your Post", body: body)
//                PostsManager.shared.posts.append(createdPost)
                profileDelegate?.didCreatePost(createdPost)
                dismiss(animated: true, completion: nil)
            } catch {
                print("Failed to create post:", error)
            }
        }
    }
}
        
        
//        let post = Post(postid: 1, authorUserName: "Timothy Chapman", createdDate: date, title: "Test 1", body: body, numComments: 0, likes: 0)
        
        
//        PostsManager.shared.createPost(post: post) { result in
//            switch result {
//            case .success(let createdPost):
//                DispatchQueue.main.async {
//                    self.delegate?.didCreatePost(createdPost)
//                    self.profileDelegate?.didCreatePost(createdPost)
//                    self.dismiss(animated: true, completion: nil)
//                }
//            case .failure(let error):
//                print("Failed to create post", error)
//            }
//        }
        
//        delegate?.didCreatePost(post)
//        profileDelegate?.didCreatePost(post)
        

//import UIKit
//
//class NewPostViewController: UIViewController, UINavigationControllerDelegate {
//    
//    @IBOutlet var newPostTextView: UITextView!
//    @IBOutlet var createPostButton: UIButton!
//    
//    weak var delegate: NewPostViewControllerDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    @IBAction func createButtonPressed(_ sender: Any) {
//        guard let body = newPostTextView.text,
//              !body.isEmpty else {
//            return
//        }
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let date = dateFormatter.string(from: Date())
//        
//        let post = Post(user: "Timothy Chapman", date: date, handle: "timothychapman", body: body, numberOfComments: "0", numberOfLikes: "0")
//        
//        delegate?.didCreatePost(post)
//        
////        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
//    }
//}
