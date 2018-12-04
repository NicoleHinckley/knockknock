//
//  CollectionDetailVC.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/7/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit


class CollectionDetailVC: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var saveButton : UIButton!
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var whiteNavBar : UIView!
    @IBOutlet weak var bottomButtonControl : UIView!
    @IBOutlet weak var selectButton : UIButton! 
    
    var isInSelectingMode : Bool = false
    var collection : Collection!
    var posts = [Post]()
    var fakeImageView = UIImageView()
    var hiddenImage : UIImageView!
    var expandedImage : UIImageView!
    var beforeExpandCellFrame: CGRect = CGRect.zero
    var topNavBarHeight : CGFloat = 64.0
    var tabBarHeight : CGFloat = 64.0
    var tapGesture : UITapGestureRecognizer!
    var selectedPost : Post!
    var selectedIndexes : [IndexPath] = []
    var collectionTap = UITapGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionTap = UITapGestureRecognizer(target: self, action: #selector(tapOnCollection(sender:)))
        collectionTap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(collectionTap)
        configureSelectButton()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.borderColor = #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1)
        deleteButton.layer.borderWidth = 1.0
        deleteButton.layer.borderColor = #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1)
        
        posts = collection.posts
//
//
//        heartAnimationView.setAnimation(named: "favorite_black")
//        heartAnimationView.contentMode = .scaleAspectFill
//        let scale : CGFloat = 3.0
//        heartAnimationView.backgroundColor = .clear
//        heartAnimationView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//
        
        whiteNavBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: topNavBarHeight)
        bottomButtonControl.frame = CGRect(x: 0, y: self.view.frame.height - tabBarHeight, width: self.view.frame.width, height: tabBarHeight)
        whiteNavBar.alpha = 0
        bottomButtonControl.alpha = 0
        
        let window = UIApplication.shared.keyWindow!
        
        window.addSubview(whiteNavBar)
        window.addSubview(bottomButtonControl)
        
        
    // Do any additional setup after loading the view.
    }
    
    
    
    @objc func tapOnCollection(sender: UITapGestureRecognizer){
        
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            guard !isInSelectingMode else { return }
            guard let cell = collectionView.cellForItem(at: indexPath) as? PostCell else { return }
            let post = posts[indexPath.row]
            selectedPost = post
            fakeImageView = UIImageView(image: cell.postImage.image)
            fakeImageView.contentMode = .scaleAspectFill
            fakeImageView.clipsToBounds = true
            let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
            let cellFrameInSuperview:CGRect!  = collectionView.convert(theAttributes.frame, to: collectionView.superview)
            fakeImageView.frame = cellFrameInSuperview
            beforeExpandCellFrame = cellFrameInSuperview
            fakeImageView.isUserInteractionEnabled = true
            self.view.addSubview(fakeImageView)
            addTapGestureToImage(fakeImageView)
            expandCell(withDuration: 0.3, forView: fakeImageView)
        } else {
            print("collection view was tapped")
            
        }
    }
    
    @IBAction func select(){
        
        if isInSelectingMode {
            deselectAllItems(animated: false)
        }
        
        isInSelectingMode = !isInSelectingMode
        configureSelectButton()
    }
    
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        for indexPath in selectedItems {
            collectionView.deselectItem(at: indexPath, animated: animated)
            let post = posts[indexPath.row]
            post.isHighlighted = false
            collectionView.reloadData()
        }
    }
    
    func configureSelectButton() {
        
        if isInSelectingMode {
            selectButton.backgroundColor =  #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1)
            selectButton.setTitleColor(.white, for: .normal)
            selectButton.layer.borderWidth = 0
            collectionView.allowsSelection = true
            collectionView.allowsMultipleSelection = true
            saveButton.isEnabled = true
            deleteButton.isEnabled = true
            saveButton.setTitleColor( #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1), for: .normal)
            deleteButton.setTitleColor( #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1), for: .normal)
            deleteButton.layer.borderColor =  #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1).cgColor
            saveButton.layer.borderColor =  #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1).cgColor
        } else {
            selectButton.backgroundColor =  .white
            selectButton.setTitleColor(#colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1), for: .normal)
            selectButton.layer.borderWidth = 1.0
            selectButton.layer.borderColor = #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1)
            //collectionView.addGestureRecognizer(collectionTap)
            collectionView.allowsSelection = false
            collectionView.allowsMultipleSelection = false
            saveButton.isEnabled = false
            deleteButton.isEnabled = false
            saveButton.setTitleColor(UIColor.lightGray, for: .normal)
            deleteButton.setTitleColor(UIColor.lightGray, for: .normal)
            deleteButton.layer.borderColor =  UIColor.lightGray.cgColor
            saveButton.layer.borderColor =  UIColor.lightGray.cgColor
        }
    }
    
    @IBAction func back (){
      self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func presentMoreOptions(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
    
        alert.addAction(UIAlertAction(title: "Report user", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func expandCell(withDuration duration: Double, forView view : UIView) {
        NotificationCenter.default.post(name: NSNotification.Name.init("ToggleScroll"), object: false)
        toggleHeart()
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            let firstKeyFrame = 0.0
            let workableSpace = self.view.frame.size.height - (self.topNavBarHeight + self.tabBarHeight)
            
            UIView.addKeyframe(withRelativeStartTime: firstKeyFrame, relativeDuration: 1) {
                view.layer.cornerRadius = 0.0
                view.layer.borderWidth = 0.0
                view.frame = CGRect(x: 0, y: self.topNavBarHeight, width: self.view.frame.width, height: workableSpace)
                self.whiteNavBar.alpha = 1.0
                self.bottomButtonControl.alpha = 1.0
            }
        })
    }
    
    func shrinkCell(withDuration duration: Double, forView view : UIView) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            view.layer.cornerRadius =  75.0 / 2
            
            view.frame = self.beforeExpandCellFrame
            self.whiteNavBar.alpha = 0
            self.bottomButtonControl.alpha = 0
        }, completion: { (completed) in
            self.fakeImageView.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name.init("ToggleScroll"), object: true)
        })
    }
    @IBAction func save(){
        for index in selectedIndexes {
            let post = posts[index.row]
            guard let postImage = post.image else { return }
            UIImageWriteToSavedPhotosAlbum(postImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil) // TODO: - Dont try to present 500 alerts here, one is enough.
        }
        
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    @IBAction func  delete(){
       
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            
            let sortedArray = indexPaths.sorted {$0.row < $1.row}
            
            guard  sortedArray.count > 0 else { return }
            for i in (0...sortedArray.count-1).reversed() {
                
               collection.posts.remove(at: sortedArray[i].row)
            }
            collectionView.deleteItems(at: sortedArray)
        }
        collectionView.reloadData()
    }

    func toggleHeart (){
        // TODO: -  fix ths mess
        let isLiked = selectedPost.isLiked
    
      
        let start : CGFloat = 0.39
        let end :CGFloat = 0.42
        let speed :CGFloat = 0.4
        if !isLiked {
        //    heartAnimationView.backgroundColor = .red
//            heartAnimationView.animationSpeed = speed
//
//            heartAnimationView.play(fromProgress: end, toProgress: start) { (completed) in
//                self.heartAnimationView.isUserInteractionEnabled = true
            
        } else { // 0.67
          //  heartAnimationView.backgroundColor = .clear
//            heartAnimationView.animationSpeed = speed
//            heartAnimationView.play(fromProgress: start + 0.01, toProgress: end){ (completed) in
//                self.heartAnimationView.isUserInteractionEnabled = true
           }
        //  self.heartAnimationView.isUserInteractionEnabled = true
        }

    @IBAction func heart(){
        toggleHeart()
        selectedPost.isLiked =  selectedPost.isLiked
    }
}

extension CollectionDetailVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        if post.isHighlighted {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: []) // (3)
        } else {
            collectionView.deselectItem(at: indexPath, animated: false) // (4)
        }
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rows : CGFloat = 3
        let spacing : CGFloat = 20
        let collectionViewWidth = collectionView.frame.width
        let space = (collectionViewWidth) - ((rows - 1 ) * spacing)
        let width = space / rows
        let size = CGSize(width: width , height:  width )
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! PostCell
        
        let post = posts[indexPath.row]//User.shared.collections[indexPath.row]
        post.isHighlighted = true
        
        selectedIndexes.append(indexPath)
        cell.toggleHighlight()
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PostCell else { return } //  TODO: - crashing here nil

        let post = posts[indexPath.row]//User.shared.collections[indexPath.row]
        post.isHighlighted = false
        
        selectedIndexes.append(indexPath)
        cell.toggleHighlight()
    }
    
    
    func addTapGestureToImage(_ imageView: UIImageView) {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedView(_:)))
        imageView.addGestureRecognizer(tapGesture)
    }
    @objc func tappedView(_ sender:UITapGestureRecognizer){
        shrinkCell(withDuration: 0.3, forView: fakeImageView)
    }
    
}


