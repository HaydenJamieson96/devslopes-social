//
//  FeedViewController.swift
//  devslopes-social
//
//  Created by TheAppExperts on 12/14/17.
//  Copyright © 2017 TheAppExperts. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CirlceView!
    @IBOutlet weak var captionField: FancyField!
    
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.posts = []
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell {
            if let img = FeedViewController.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)                
            }
            return cell
        } else {
            return PostTableViewCell()
        }
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("HAYDEN: id removed from keychain \(keyChainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("HAYDEN: Valid image not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("HAYDEN: Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("HAYDEN: An image must be selected")
            return
        }
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAEGS.child(imgUid).putData(imageData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("HAYDEN: unable to upload image to Firebase storage")
                } else {
                    print("HAYDEN: Successfully uploaded image to Firebase storage")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, Any> = [
        "caption" : captionField.text!,
        "imageUrl" : imgUrl,
        "likes" : 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
    }
    
    
    
    
    
    
   

}
