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
                profileDelegate?.didCreatePost(createdPost)
                dismiss(animated: true, completion: nil)
            } catch {
                print("Failed to create post:", error)
            }
        }
    }
}
