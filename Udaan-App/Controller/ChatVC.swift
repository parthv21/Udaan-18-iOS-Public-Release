//
//  ChatVC.swift
//  Udaan-App
//
//  Created by Parth Tamane on 30/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
class ChatVC: MessagesViewController {

    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var chatsTitleBar: UINavigationItem!
        
    var messageList: [Message] = []
    var messageSender: Sender!
    var receiver_Tokens = [String]()
    
    var userFCMToken = Messaging.messaging().fcmToken
    let user = Auth.auth().currentUser
    
    //var ref: DatabaseReference!
    
    var isComittee = false
    
    var receiverEmail = ""
    var receiverName = ""
    
    let userPlaceHolder = "Ask us something?"
    let committeePlaceHolder = "Reply to All"
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var messageAllBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Token from message obj: ", userFCMToken ?? "BAD_TOKEN")
        
        
        let userTokenDictionary = ["name":user?.displayName, "token":userFCMToken]
        
        tokenRef.child((user?.uid)!).setValue(userTokenDictionary)
        
        self.navigationItem.backBarButtonItem = backButton
        
        messageSender = Sender(id: (user?.email)!, displayName: (user?.displayName)!)
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        messagesCollectionView.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
    
        
        scrollsToBottomOnKeybordBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        isComittee = committee.contains(messageSender.id) ? true : false
    
        messageInputBar.inputTextView.placeholder = isComittee ? committeePlaceHolder : userPlaceHolder
        
        receiverEmail = isComittee ? "All" : (user?.email)!
        receiverName = isComittee ? "All" : (user?.displayName)!
        receiver_Tokens = isComittee ? ["All"] : committeeTokens
        
        if isComittee {
            
            if !committeeTokens.contains(userFCMToken ?? "") {
                
                committeeFCMTokenRef.child(user?.displayName ?? "NO_NAME").setValue(userFCMToken)
                print("Token value of commitee member ",user?.displayName ?? "NO_NAME" ,"is changed.\nNew value is: \n",userFCMToken,"\n")
            } else {
                
                print("The token was not changed\n")
            }
        }
        
        print("\n\nReceiver tokens are: \n",receiver_Tokens,"\n\n")
        
        messageAllBtn.isEnabled = false
        
        chatsTitleBar.title = isComittee ? "Answer Doubts" : "Q & A"
        
        committeeChats.observe(.value, with: {(snapshot) in
            
            var messageCount = 0
            
            self.messageList.removeAll()
            
            if let value = snapshot.value as? Dictionary<String,Any> {
                
                for (index,messageBody) in value {
                    

                    if let messageBody = messageBody as? Dictionary<String,Any> {
                    
                        guard let userId = messageBody["email"] as? String, let userName = messageBody["name"] as? String, let text = messageBody["text"] as? String, let timeStamp = messageBody["time"] as? Double, let rec_email = messageBody["rec_email"] as? String, let rec_name = messageBody["rec_name"] as? String else { print("Error in fetching message"); return }
                        
                        
                        let token = messageBody["token"] as? String
                        
                        var senderToken: String!
                        
                        if let token = token {
                          senderToken = token
                        } else {
                            
                            senderToken = "TOKEN_DOES_NOT_EXIST"
                            
                        }
                       
                        if self.user?.email == rec_email && self.user?.email != userId || rec_email == "All" {
                            
                            messageCount += 1
                            
                        }
                        
                        var sender = Sender(id: userId, displayName: userName)
                        
                        if committee.contains(userId) {
                            
                            if userId == "parthv21@gmail.com" {
                                sender = Sender(id: userId, displayName: userName + " 👨🏾‍💻")
                            } else {
                                sender = Sender(id: userId, displayName: userName + " ⭐️")
                            }
                        }
                        
                        if userId == self.user?.email {
                            
                            sender = Sender(id: userId, displayName: "You")
                        }
                        
                        if self.isComittee {
                            
                            if rec_email != self.messageSender.id && userId == self.messageSender.id {
                                
                                //text = text + "\n\n To: " + rec_name + ""
                                sender = Sender(id: userId, displayName: "You (\(rec_name))")
                            
                            }
                        }
                        
                        let message = Message(message: text  , sender: sender, id: senderToken, timeInterval: timeStamp)
                        
                        
                        if self.isComittee {
                        
                        self.messageList.append(message)
                        
                        } else if self.receiverEmail == rec_email || rec_email == "All" {
                            
                            self.messageList.append(message)
                        }
                    }
                }
                
            }
        
            self.messageList =  self.messageList.sorted(by: { (first,second) -> Bool in
                
                if first.sentDate.timeIntervalSince1970 < second.sentDate.timeIntervalSince1970 {
                    return true
                } else {
                    return false
                }
                
            })
            
            if self.isComittee {
                
                if self.messageList.count != self.defaults.object(forKey: "messageCount") as! Int {
                    print("Chat VC: Setting value: ",self.messageList.count)
                    self.defaults.set(self.messageList.count, forKey: "messageCount")
                }
            } else {
                
                if let oldCount = self.defaults.object(forKey: "messageCount") as? Int {
                    
                    print(messageCount,oldCount)
                    
                    if messageCount != oldCount {
                        print("Here")
                        self.defaults.set(messageCount, forKey: "messageCount")
                    }
                }
            }
            
            self.messagesCollectionView.reloadDataAndKeepOffset()
            self.messagesCollectionView.scrollToBottom()
           
        })
    
        self.messagesCollectionView.scrollToBottom()
    }
    
    //MARK: - IBAcation
    
    
    @IBAction func dissmissChatGestureTriggered(_ sender: Any) {
        dismiss(animated: true)
    }
    

    @IBAction func dismissChat(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    
    @IBAction func messageAll(_ sender: Any) {
        
        replyAll()
        
    }
    
    //MARK: - Reply to all settings
    
    func replyAll() {
        
        if !isComittee { return }
        
        receiverEmail = "All"
        receiverName = "All"
        receiver_Tokens = ["All"]
        messageAllBtn.isEnabled = false
        
        messageInputBar.inputTextView.placeholder = committeePlaceHolder
        
    }
    
    //MARK: - Dismiss Keyboard
    
    @objc func dismissKeyboard() {
        
        messageInputBar.inputView?.resignFirstResponder()
    }
    
}

// MARK: - MessagesDataSource

extension ChatVC: MessagesDataSource {
    
    func currentSender() -> Sender {
        return messageSender
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messageList[indexPath.section]
        
    }
    
    func avatar(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar {
        
        return Avatar(image: UIImage(), initials: "SS")
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        struct ConversationDateFormatter {
            static let formatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter
            }()
        }
        let formatter = ConversationDateFormatter.formatter
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}

// MARK: - MessageLabelDelegate

extension ChatVC: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String : String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
        
        guard let phoneURL = URL(string: "tel://" + phoneNumber) else { return }
        
        if UIApplication.shared.canOpenURL(phoneURL) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(phoneURL)
                
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(phoneURL)
            }
        }
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
        UIApplication.shared.openURL(url)
    }
}

// MARK: - MessageInputBarDelegate

extension ChatVC: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        let user = Auth.auth().currentUser
        
        let messageBody = ["email": user?.email!,"name": user?.displayName ?? "NO_NAME","rec_email": receiverEmail, "text": text, "time":  NSDate().timeIntervalSince1970, "rec_name": receiverName, "token": userFCMToken, "rec_tokens": receiver_Tokens ] as [String : Any]
        
        print("Message body is: ",messageBody)
        committeeChats.childByAutoId().setValue(messageBody)
       
        inputBar.inputTextView.text = String()
    
        inputBar.inputTextView.placeholder = isComittee ? committeePlaceHolder : userPlaceHolder
        
        inputBar.inputTextView.resignFirstResponder()
        
        replyAll()
        
        messagesCollectionView.scrollToBottom()
    
    }
    
}

// MARK: - MessageCellDelegate

extension ChatVC: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
        
        
        if isComittee {
            
            messageAllBtn.isEnabled = true
            
            
            if let path = messagesCollectionView.indexPath(for: cell) {
                
                let messageSenderEmail = messageForItem(at: path, in: messagesCollectionView).sender.id
                let messageSenderName =   messageForItem(at: path, in: messagesCollectionView).sender.displayName
                let senderToken = messageForItem(at: path, in: messagesCollectionView).messageId
                
                if committee.contains(messageSenderEmail) {
                    
                    replyAll()
                    
                
                } else {
                    
                    receiverEmail = messageSenderEmail
                    receiverName = messageSenderName
                    receiver_Tokens = ["\(senderToken)"]
                    
                    print("Receiever token is: ",receiver_Tokens)
                    
                    messageInputBar.inputTextView.placeholder = "Reply to \(receiverName)"
                }
                
                chatsTitleBar.title = "Reply: \(receiverName)"
            }
        }
    }
    
    func didTapTopLabel(in cell: MessageCollectionViewCell) {
        print("Top label tapped")
        
    }
    
    func didTapBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
}

// MARK: - MessagesLayoutDelegate

extension ChatVC: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition(horizontal: .natural, vertical: .messageBottom)
    }
    
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        if isFromCurrentSender(message: message) {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
        }
    }
    
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        } else {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        }
    }
    
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        } else {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: messagesCollectionView.bounds.width, height: 10)
    }
    
    // MARK: - Location Messages
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 200
    }
    
}

// MARK: - Message Display Delegate

extension ChatVC: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey : Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        //return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        return isFromCurrentSender(message: message) ? UIColor(red:0.28, green:0.80, blue:1.00, alpha:1.0) : UIColor(red:0.93, green:0.95, blue:0.95, alpha:1.0)
        
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft

        return .bubbleTail(corner, .curved)
        let configurationClosure = { (view: MessageContainerView) in }
        return .custom(configurationClosure)
    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(0, 0, 0)
            view.alpha = 0.0
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
                view.alpha = 1.0
            }, completion: nil)
        }
    }
}

class Message: MessageType {
    
    var sender: Sender
    
    var messageId: String
    
    var sentDate: Date
    
    var data: MessageData
    
    init(message: String,sender: Sender,id: String, timeInterval: Double ) {
        
        self.data = MessageData.text(message)
        self.sender = sender
        self.sentDate = Date(timeIntervalSince1970: timeInterval)
        self.messageId = id
    }
    
}
