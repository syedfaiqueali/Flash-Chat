//
//  NewChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Faiq on 15/05/2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NewChatViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!

    private var refChat = Database.database().reference(withPath: "messages/ticket_01")
    
    private var arrMessages = [TextMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register message XIB
        tblView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        listenerToFetchMessages()
    }
    
    @IBAction func btnNewMessageClicked(_ sender: Any) {
        //Write data
        let newTextRef = self.refChat.childByAutoId()
        let textObj:[String: Any] = [
            "text": "Hello new \(arrMessages.count)",
            "timestamp": 12334444444,
            "userType": 1]
        newTextRef.setValue(textObj)
    }
    
    func listenerToFetchMessages() {
        refChat.observe(.value) { snapshot in
            if snapshot.childrenCount > 0 {
                //Remove all
                self.arrMessages.removeAll()
                
                //Fetch all
                for text in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let textObj = text.value as? [String: AnyObject] else {return}
                    self.arrMessages.append(
                        TextMessage(
                            text: textObj["text"] as? String ?? String(),
                            timestamp: textObj["timestamp"] as? Int ?? 0,
                            userType: textObj["userType"] as? Int ?? 0
                        ))
                }
                
                //Reload
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
}

extension NewChatViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = arrMessages[indexPath.row].text
        
//        //This message is from current user
//        if message.sender == Auth.auth().currentUser?.email {
//            cell.leftImageView.isHidden = true
//            cell.rightImageView.isHidden = false
//            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
//            cell.label.textColor = UIColor(named: K.BrandColors.purple)
//        }
//
//        //This is message from another user
//        else{
//            cell.leftImageView.isHidden = false
//            cell.rightImageView.isHidden = true
//            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
//            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
//        }
        
        
        return cell
    }
}

struct TextMessage {
    let text: String?
    let timestamp: Int?
    let userType: Int?
    
    init(text: String, timestamp: Int, userType: Int) {
        self.text = text
        self.timestamp = timestamp
        self.userType = userType
    }
}


//https://swiftbyshanks.medium.com/5-steps-to-setup-cloud-messaging-using-firebase-on-ios-385aceea331c
