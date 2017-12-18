//
//  PostTableViewCell.swift
//  devslopes-social
//
//  Created by TheAppExperts on 12/15/17.
//  Copyright © 2017 TheAppExperts. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var likesRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)

        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("HAYDEN: Unable to download image from Firebase storage")
                } else {
                    print("HAYDN: IMG downloaded from storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedViewController.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        }
    }
    
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addlike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addlike: false)
                self.likesRef.removeValue()
            }
        }
    }

   

}
