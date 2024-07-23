//
//  Protocols.swift
//  YearLongProject
//
//  Created by Timothy Chapman on 7/10/24.
//

import Foundation

protocol NewPostViewControllerDelegate: AnyObject {
    func didCreatePost(_ post: Post)
}

protocol PostCreationNotifcationDelegate: AnyObject {
    func didCreatePost(_ post: Post)
}

protocol SettingsDelegate: AnyObject {
    func didUpdateProfile(name: String?, bio: String?, interests: String?)
}

