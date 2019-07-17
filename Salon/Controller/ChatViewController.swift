//
//  ChatViewController.swift
//  Salon
//
//  Created by 刘恒宇 on 9/28/18.
//  Cop0yright © 2018 Hengyu Liu. All rights reserved.
//

import Firebase
import UIKit
import FirebaseFirestore

class ChatViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var temTitle: String! {
        didSet {
            navigationItem.title = temTitle
        }
    }
    
    lazy var functions = Functions.functions()
    
    // MARK: - FireBase API
    var db: Firestore!
    var messages = [MessageDetailModel]()
    var reservationID: String? {
        didSet {
            print("lhy get reservationID \(reservationID)")
            observeMessages()
        }
    }
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func observeMessages() {
        db = Firestore.firestore()
        guard let id = self.reservationID else {
            return
        }
        let roomRef = db.collection("chatDetail").document(id).collection("chat")
        
        roomRef.addSnapshotListener { (sn, err) in
            guard err == nil, let sn = sn else {
                return
            }
            for change in sn.documentChanges {
                switch change.type {
                case .added:
                    self.messages.append(MessageDetailModel(data: change.document.data()))
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    })
                default:
                    continue
                }
            }
        }
    }

    // MARK: - Life Cycle
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        
        view.addSubview(inputContainerView)
        containerViewBottomAnchor = inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        self.navigationItem.backBarButtonItem?.title = "Message"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Collection View
    
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.chatLogController = self
        
        let message = messages[indexPath.item]
        cell.textView.text = message.message
        setupCell(cell, message: message)
        
        if let text = message.message {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
            cell.textView.isHidden = false
        }
        
        return cell
    }
    
    fileprivate func setupCell(_ cell: ChatMessageCell, message: MessageDetailModel) {
        if message.senderID == Auth.auth().currentUser?.uid {
            // outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true

            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false

        } else {
            // incoming gray
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = true

            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        cell.messageImageView.isHidden = true
    }
    
    override func viewWillTransition(to _: CGSize, with _: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if indexPath.item >= self.messages.count {
            return CGSize(width: 0, height: 0)
        }
        
        let message = messages[indexPath.item]
        
        if let text = message.message{
            height = estimateFrameForText(text).height + 20
        }
        
        // let width = UIScreen.main.bounds.width
        return CGSize(width: view.frame.width, height: height)
    }
    
    // MARK: - Keyboard and inputContainer related
    
    lazy var inputContainerView: ChatInputContainerView = {
        let chatInputContainerView = ChatInputContainerView()
        chatInputContainerView.chatLogController = self
        chatInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        return chatInputContainerView
    }()

    var backgroundView: UIView?
    var moreSelectionViewEnabled = false
    var moreSelectionViewIsAnimating = false

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        messages.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        if let height = self.tabBarController?.tabBar.frame.height {
            containerViewBottomAnchor?.constant += height
        }
        
        DispatchQueue.main.async {
            if self.messages.count > 0 {
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
            }
        }
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // estimation of height
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    @objc func handleSend() {
        guard let messageText = inputContainerView.inputTextField.text else {
            fatalError("[ChatLog] Input should not be nil")
        }
        if messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            inputContainerView.inputTextField.text = ""
            inputContainerView.inputTextField.shake(2, withDelta: 4, speed: 0.07)
        } else {
            let properties = ["message": inputContainerView.inputTextField.text!]
            sendMessageWithProperties(properties as [String: AnyObject])
        }
    }

    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        let toId = reservationID!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        
        var values: [String: AnyObject] = ["senderId": fromId as AnyObject, "time": timestamp as AnyObject, "reservationID": toId as AnyObject]
        
        // append properties dictionary onto values somehow??
        // key $0, value $1
        properties.forEach({ values[$0] = $1 })
        
        functions.httpsCallable("sendMessage").call(values) { (result, err) in
            guard err == nil else {
                print(err)
                self.inputContainerView.inputTextField.shake(2, withDelta: 4, speed: 0.07)
                return
            }
            print("Message sent")
            self.inputContainerView.inputTextField.text = ""
        }
    }
}
