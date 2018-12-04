//
//  CollectionsVC.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/4/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit

// TODO: - Make labels not user interactable on cells
// TODO: -  Change varhow selecting works. Probably store the index paths myself

class CollectionsVC : UIViewController {
    

    var collections = [Collection]()
    var topNavBarHeight : CGFloat = 64.0
    var tabBarHeight : CGFloat = 64.0
  
    
    var selectedIndexes : [IndexPath] = []
    
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var saveButton : UIButton!
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var selectButton : UIButton!

    
    var isInSelectingMode : Bool = false
    var hiddenImage : UIImageView!
    var expandedImage : UIImageView!
    var beforeExpandCellFrame: CGRect = CGRect.zero

    var collectionTap = UITapGestureRecognizer()
    
    
    var tappedCollection : Collection!
    var refreshTimer = Timer()
    
    override func viewDidLoad() {
        // TODO: - Make a subclass
        
        refreshTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)//(timeInterval: 5.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        observePosts()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.borderColor = #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1)
        deleteButton.layer.borderWidth = 1.0
        deleteButton.layer.borderColor = #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1)
        
        configureSelectButton()
       
    
        collectionTap = UITapGestureRecognizer(target: self, action: #selector(tapOnCollection(sender:)))
        collectionTap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(collectionTap)
   
    }
    
    
    func observePosts(){
        
        FIRFireStoreService.shared.observeUsersJoinedCollections { (collections, error) in
            if let err = error {
                self.alert(message: err.localizedDescription)
            } else {
                guard let collections = collections else { return }
                self.collections = collections // TODO: - FIx all this
                self.collectionView.reloadData()
            }
        }
    }
    
    // TODO: - Either set a timer to refresh the collection view every 5 seconds, or schedule a timer for each cell on view appear.
    
    @objc func timerFired(){
        self.collectionView.reloadData()
    }
    @objc func tapOnCollection(sender: UITapGestureRecognizer){
        
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            guard !isInSelectingMode else { return }
            let cell = self.collectionView?.cellForItem(at: indexPath)
            
            let collection = CurrentUser.shared.collections[indexPath.row]// TODO: - crash index out of range
            
            guard collection.locked == false else { return }
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CollectionDetailVC") as! CollectionDetailVC
            controller.collection = collection
           self.performSegue(withIdentifier: "toCollectionDetailVC", sender: collection)
            
        } else {
            print("collection view was tapped")
          
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCollectionDetailVC" {
            guard let destination = segue.destination as? CollectionDetailVC else { return }
            destination.collection = sender as? Collection
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
         //   collectionView.addGestureRecognizer(collectionTap)
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
    
    func fetchCollections() {
    //  self.collections = User.shared.collections
    }
    
    @IBAction func save(){
        
    }
    @IBAction func  delete(){
        
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            
            let sortedArray = indexPaths.sorted {$0.row < $1.row}
            
            
            
            guard  sortedArray.count > 0 else { return }
            for i in (0...sortedArray.count-1).reversed() {
                
                 CurrentUser.shared.collections.remove(at: sortedArray[i].row)
            }
            collectionView.deleteItems(at: sortedArray)
         }
        collectionView.reloadData()
    }
    
    @IBAction func select(){
        
        if isInSelectingMode {
            deselectAllItems(animated: false)
        }
        
        isInSelectingMode = !isInSelectingMode
        configureSelectButton()
    }
 
}


extension CollectionsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
       
        let collection = collections[indexPath.row]
        let now = NSDate().timeIntervalSince1970
        let fourMinsAgo = now - (60 * 4)
        let timeDifference = (fourMinsAgo - collection.timeInitiated)
        
        if timeDifference > 0 {
            collection.locked = false
        } else {
            collection.locked = true
        }
       
        if collection.isHighlighted {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: []) // (3)
        } else {
            collectionView.deselectItem(at: indexPath, animated: false) // (4)
        }
        
        cell.collection = collection
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

 //        print(collections[indexPath.row].locked)
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionCell
        
        let collection = CurrentUser.shared.collections[indexPath.row]
        collection.isHighlighted = true
        
        selectedIndexes.append(indexPath)
        cell.toggleHighlight()
   
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell else { return } //  TODO: - crashing here nil
        let collection = CurrentUser.shared.collections[indexPath.row]
        collection.isHighlighted = false
        cell.toggleHighlight()
    }
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        for indexPath in selectedItems {
            collectionView.deselectItem(at: indexPath, animated: animated)
            let collection = CurrentUser.shared.collections[indexPath.row]
            collection.isHighlighted = false
            collectionView.reloadData()
        }
    }
}

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        let window = UIApplication.shared.keyWindow!
        
        window.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
   
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}
