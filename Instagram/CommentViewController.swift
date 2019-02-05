//
//  CommentViewController.swift
//  Instagram
//
//  Created by 磯翔野 on 2019/01/31.
//  Copyright © 2019 shono.iso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    
    var postdata:PostData!
    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func sendCommentButton(_ sender: Any) {
        let time = Date.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        let postRef = Database.database().reference().child(Const.PostPath).child("\(postdata.id!)").child("comments")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDic = ["caption": self.textField.text!,"time": String(time),  "name": name!]
            //postRef.childByAutoId().setValue(postDic)
            let NumChild = snapshot.childrenCount + 1
            postRef.child(NumChild.description).setValue(postDic)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButton(_ sender: Any) {
        // 画面を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
