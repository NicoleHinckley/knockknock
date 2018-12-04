//
//  BubblesVC.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/4/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

// TODO: - Stop scroll view when expanded
// TODO: - Add commit block to animation for new bubbles being created on the fly

import UIKit
import Photos
import Firebase

class BubblesVC : UIViewController {


    var topNavBarHeight : CGFloat = 64.0
    var tabBarHeight : CGFloat = 50.0
    var panGesture = UIPanGestureRecognizer()
    var longPressGesture = UILongPressGestureRecognizer()
    var tapGesture = UITapGestureRecognizer()
    var doubleTapGesture = UITapGestureRecognizer()
    var bubbles = [BubbleView]()
    var collections = [Collection]()
    var hiddenBubble : BubbleView!
    var expandedBubble : BubbleView!
    
    var hasDoneInitialBubbleFetch = false
    
    var beforeExpandBubbleFrame: CGRect = CGRect.zero
    
    var collectionsParticipatedIn = [Collection]()
    
    @IBOutlet weak var whiteNavBar : UIView!
    @IBOutlet weak var whiteTabBar : UIView!
    @IBOutlet weak var bubblesStackView : UIStackView!
    
    var nameLabel : UILabel!
   
    override func viewDidLoad() {
        
        observePosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTakePicture(_:)), name: NotificationNames.DID_TAKE_PICTURE, object: nil)
        
        addDoubleTapToScreen()
       
        whiteNavBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: topNavBarHeight)
        whiteTabBar.frame = CGRect(x: 0, y: self.view.frame.height - tabBarHeight, width: self.view.frame.width, height: tabBarHeight)
       
        whiteNavBar.alpha = 0
        whiteTabBar.alpha = 0
        
        let window = UIApplication.shared.keyWindow!
        
        window.addSubview(whiteNavBar)
        window.addSubview(whiteTabBar)
    
    }
    
    func observePosts(){
        
        FIRFireStoreService.shared.observeJoinableCollections { (collections, error) in
            if let err = error {
                self.alert(message: err.localizedDescription)
            } else {
                guard let collections = collections else { return }
                for collection in collections {
                    let bubble = BubbleView(position: CGPoint(x: collection.xPos, y: collection.yPos), collection: collection)
                    self.createBubble(bubble)
                    self.addBubbleTimerAnimationWithCompletion(bubble)
                }
            }
        }
    }
    
    func createBubble(_ bubble : BubbleView){
        bubble.backgroundColor = .green
        
        bubble.isUserInteractionEnabled = true
        bubble.adjustsImageWhenHighlighted = false
        self.view.addSubview(bubble)
        addLongPressToBubble(bubble)
        addPanToBubble(bubble)
        addDoubleTapToBubble(bubble)
    }
    
    func calculateTimerFor(bubble : BubbleView){
        let now = NSDate().timeIntervalSince1970
        let fourMinsAgo = now - (60 * 4)
        
        let timeDifference = abs(fourMinsAgo - bubble.collection.timeInitiated)
        let percentage = 1 - abs(timeDifference / (4 * 60))
        
        bubble.animateCircle(duration: timeDifference , fromValue : percentage)
    }
 
        
        func addBubbleTimerAnimationWithCompletion(_ bub : BubbleView){
            CATransaction.begin()
            
            CATransaction.setCompletionBlock({
                bub.isShrinking = true 
        
                UIView.animate(withDuration: 1, animations: {
                    
                    bub.circleLayer.lineWidth = 7.0
                    bub.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1) // TODO: - Animate
                }, completion: { (completed) in
                    bub.removeFromSuperview() // TODO: - Is there a reason to update the data model here?
                })
                
            })
            calculateTimerFor(bubble: bub)
            CATransaction.commit()
        }
    
    
    var isInitiating : Bool = false
    @objc func didTakePicture(_ notification:Notification) {
        // Do something now
        guard let image = notification.object as? UIImage else { return }
        
        if isInitiating {
        createCollection(withImage: image, atLocationInView: locationInViewToInitiatePost)
        } else {
        respondToBubble(withImage: image)
        }
    }
    
    func addDoubleTapToScreen(){
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTappedView(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
    }
    func addDoubleTapToBubble(_ bubble : BubbleView){
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTappedBubbleView(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        bubble.addGestureRecognizer(doubleTapGesture)
    }
    func addLongPressToBubble(_ bubble : BubbleView){
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressedView(_:)))
        longPressGesture.minimumPressDuration = 0.2
        bubble.addGestureRecognizer(longPressGesture)
    }
    func addPanToBubble(_ bubble: BubbleView){
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        bubble.addGestureRecognizer(panGesture)
    }
    
    func addTapGestureToBubble(_ bubble: BubbleView) {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedView(_:)))
        bubble.addGestureRecognizer(tapGesture)
    }
    
    
    func expand(bubble : BubbleView, withDuration duration: Double, forView view : UIView) {
        
        var index = 1
        for participationBub in bubblesStackView.arrangedSubviews {
            guard let participationBubble = participationBub as? ParticipationCountBubble else { return }
            let numberOfParticipants = bubble.collection.posts.count
            if index <= numberOfParticipants {
                participationBubble.tag = 1
                participationBubble.setupColor()
            } else {
                participationBubble.tag = 2
                participationBubble.setupColor()
            }
            index = index + 1
        }
                
        NotificationCenter.default.post(name: NSNotification.Name.init("ToggleScroll"), object: false)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            let firstKeyFrame = 0.0
            let workableSpace = self.view.frame.size.height - (self.topNavBarHeight + self.tabBarHeight)
            
            UIView.addKeyframe(withRelativeStartTime: firstKeyFrame, relativeDuration: 1) {
                view.layer.cornerRadius = 0.0
                view.layer.borderWidth = 0.0
                view.frame = CGRect(x: 0, y: self.topNavBarHeight, width: self.view.frame.width, height: workableSpace)
                self.whiteNavBar.alpha = 1.0
                self.whiteTabBar.alpha = 1.0
            }
        })
    }
    
    func shrinkBubble(withDuration duration: Double, forView view : UIView) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            view.layer.cornerRadius =  75.0 / 2
            
            view.frame = self.hiddenBubble.frame
            self.whiteNavBar.alpha = 0
            self.whiteTabBar.alpha = 0
        }, completion: { (completed) in
            self.hiddenBubble.isHidden = false
            self.expandedBubble.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name.init("ToggleScroll"), object: true)
        })
    }
    
 
    @objc func tappedView(_ sender:UITapGestureRecognizer){
        shrinkBubble(withDuration: 0.3, forView: expandedBubble)
    }
    
     @objc func doubleTappedView(_ sender:UITapGestureRecognizer){
        isInitiating = true
    
        locationInViewToInitiatePost = CGPoint(x : sender.location(in: self.view).x - (75 / 2) , y: sender.location(in: self.view).y - (75 / 2))
        createCollection(withImage: #imageLiteral(resourceName: "ygritte"), atLocationInView: locationInViewToInitiatePost)
        NotificationCenter.default.post(name: NotificationNames.TAKE_PICTURE, object: true)
    }
    
    var locationInViewToInitiatePost = CGPoint()
    var bubbleToRespondTo : BubbleView!
    
    func createCollection(withImage image : UIImage, atLocationInView location: CGPoint){
        
        let time = NSDate().timeIntervalSince1970
        
        guard let imageData = image.pngData() else { return }
        
        FIRStorageService.shared.addPostImage(withImageData: imageData) { (url, error) in
            if let error = error {
                self.alert(message: error.localizedDescription)
            } else {
                guard let currentUID = Auth.auth().currentUser?.uid else { return }
                guard let url = url else { return }
                let uid =  UUID.init().uuidString
                let collectionInfo : [String : Any ] = [
                    "thumbnailURL" : url.absoluteString,
                    "timeInitiated" : time,
                    "posts" : "todo", // TODO: -
                    "posterUID" : currentUID,
                    "uid" : uid,
                    "xPos" : location.x,
                    "yPos" : location.y
                    ]
                FIRFireStoreService.shared.createCollection(withUID: uid, withData: collectionInfo, completion: { (collection, error) in
                    print("Got it")
                })
        }
    }
}
 
    func respondToBubble(withImage image: UIImage){
        
        /*
        for post in bubbleToRespondTo.collection.posts {
            if post.posterUID == UserData.shared.currentUser.uid { // TODO: -  fix
                print("Already joined in")
                return
            }
        }
      
        let timePosted  = NSDate().timeIntervalSince1970
        
        ]
        
        guard let post = Post(dictionary: postInfo) else { return } // TODO: - error handle
     
        bubbleToRespondTo.collection.posts.append(post)
        collectionsParticipatedIn.append(bubbleToRespondTo.collection)
 
 */
    }
    
    @objc func doubleTappedBubbleView(_ sender:UITapGestureRecognizer){
        
        isInitiating = false
     guard let  bubbleTapped = sender.view as? BubbleView else { return }
        if bubbleTapped.isShrinking {
            print("Too late, sucker")
            return }
        NotificationCenter.default.post(name: NotificationNames.TAKE_PICTURE, object: nil)
        bubbleToRespondTo = bubbleTapped
    }
    
    @objc func longPressedView(_ sender:UILongPressGestureRecognizer){
        if sender.state == .began {
            guard let bubble = sender.view as? BubbleView else { return }
            let position = CGPoint(x: bubble.center.x - (bubble.frame.size.width / 2), y: bubble.center.y - (bubble.frame.size.width / 2))
            let fakeBubble = BubbleView(position: position, collection : bubble.collection)
            addTapGestureToBubble(fakeBubble)
            bubble.isHidden = true
            hiddenBubble = bubble
            expandedBubble = fakeBubble
            view.addSubview(fakeBubble)
            expand(bubble : bubble, withDuration: 0.3, forView: fakeBubble)
        }
       
        
    }
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        
        
        // TODO: - Animation goes crazy if post ends while dragging it around.
        // TODO: - Restrict from going outside and make this safer with guard let
        self.view.bringSubviewToFront(sender.view!)
        
        let translation = sender.translation(in: self.view)
        
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        let duration = 0.2
        if sender.state == .began {
            UIView.animate(withDuration: duration) {
                sender.view!.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
        }
        if sender.state == .ended {
            UIView.animate(withDuration: duration) {
                sender.view!.transform = .identity
            }
            
            guard let  bubbleTapped = sender.view as? BubbleView else { return }
            FIRFireStoreService.shared.updateBubbleLocation(uid: bubbleTapped.collection.uid, withPosition: bubbleTapped.center)
        }
    }
}

extension Double {
    var fourMinutes : Double {
        return (6 * 40)
    }
}

