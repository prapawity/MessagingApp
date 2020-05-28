//
//  ImageManager.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 19/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage


protocol ImageManagerProtocol {
    func uploadeUserAvatar(email: String, image: UIImage, completion: @escaping (Result, String) -> Void)
    func downloadImage(path: String,completion: @escaping (Result, UIImage) -> Void)
}

struct  ImageManager: ImageManagerProtocol{
    private let storageRef = Storage.storage().reference()
    
    
    
    
    func downloadImage(path: String, completion: @escaping (Result, UIImage) -> Void) {
        let pathRef = storageRef.child(path)
        pathRef.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            if error != nil || path == "" {
                completion(.failed, #imageLiteral(resourceName: "logo"))
            } else {
              let image = UIImage(data: data!)
                completion(.success, image!)
            }
        }
    }
    

    func uploadeUserAvatar(email: String, image: UIImage, completion: @escaping (Result, String) -> Void) {
        let riversRef = storageRef.child("\(email)/avatar.png")
        
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            riversRef.putData(uploadData, metadata: nil) { (storage, error) in
                guard error == nil else{
                    
                    return completion(.failed, error!.localizedDescription)
                }
                return completion(.success, (storage?.path)!)
            }
        }
    }
    
    
}
