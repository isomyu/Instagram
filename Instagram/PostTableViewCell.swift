//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 磯翔野 on 2019/01/31.
//  Copyright © 2019 shono.iso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PostTableViewCell: UITableViewCell ,UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var commentArray: [Comment] = []
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.delegate = self
        tableView.dataSource = self
        // テーブルセルのタップを無効にする
        
        tableView.allowsSelection = false
        
        let nib2 = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "Cell2")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableView.automaticDimension
        // テーブル行の高さの概算値を設定しておく
        // 高さ概算値 = 「縦横比1:1のUIImageViewの高さ(=画面幅)」+「いいねボタン、キャプションラベル、その他余白の高さの合計概算(=100pt)」
        tableView.estimatedRowHeight = 100
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func setPostData(_ postData: PostData) {
        
        self.postImageView.image = postData.image
        
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する
                let commentRef = Database.database().reference().child(Const.PostPath).child("\(postData.id!)").child("comments")
                commentRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        let commentData = Comment(snapshot: snapshot)
                        self.commentArray.insert(commentData, at: 0)
                        // TableViewを再表示する
                        //print(self.tableView)
                        self.tableView.reloadData()
                        //print(self.tableView)
                        
                    }
                })
                
                // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                commentRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        // PostDataクラスを生成して受け取ったデータを設定する
                        //let postData = PostData(snapshot: snapshot, myId: uid)
                        let commentData = Comment(snapshot: snapshot)
                        // 保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.commentArray {
                            if post.id == commentData.id! - 1 {
                                index = self.commentArray.index(of: post)!
                                break
                            }
                        }
                        
                        // 差し替えるため一度削除する
                        self.commentArray.remove(at: index)
                        
                        // 削除したところに更新済みのデータを追加する
                        self.commentArray.insert(commentData, at: index)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                })
                
                // DatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
                observing = true
            }
        } else {
            if observing == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                commentArray = []
                self.tableView.reloadData()
                // オブザーバーを削除する
                Database.database().reference().removeAllObservers()
                
                // DatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                observing = false
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! CommentTableViewCell
        cell.setComment(commentArray[indexPath.row])
        
        return cell
    }
}
    
    

