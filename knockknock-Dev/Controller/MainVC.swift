//
//  MainVC.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/3/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit

class MainVC : UIViewController {
   
        // MARK: - IBOutlets
        @IBOutlet var navigationView: NavigationView!
    
        // MARK: - Properties

    override func viewDidLoad() {
    
        let timePosted  = NSDate().timeIntervalSince1970
     
    }
    
        override var prefersStatusBarHidden: Bool {
            return true
        }
    
        var scrollViewController: ScrollViewController!
    
    
    
        lazy var bubblesVC: UIViewController! = {
            return self.storyboard?.instantiateViewController(withIdentifier: "BubblesVC")
        }()
        
        lazy var friendsVC: UIViewController! = {
            return self.storyboard?.instantiateViewController(withIdentifier: "FriendsVC")
        }()
        
        lazy var collectionsVC: UIViewController! = {
            return self.storyboard?.instantiateViewController(withIdentifier: "CollectionsVC")
        }()
        
        var cameraVC: CameraVC!

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if let controller = segue.destination as? CameraVC {
            cameraVC = controller
        } else if let controller = segue.destination as? ScrollViewController {
            scrollViewController = controller
            scrollViewController.delegate = self
        }
    }
}


// MARK: - IBActions
extension MainVC {
    
    @IBAction func handleBubblesIconTap(_ sender: UIButton) {
        scrollViewController.setController(to: bubblesVC, animated: true)
    }
    
    @IBAction func handleFriendsIconTap(_ sender: UIButton) {
        scrollViewController.setController(to: friendsVC, animated: true)
    }
    
    @IBAction func handleCollectionsButton(_ sender: UIButton) {
        scrollViewController.setController(to: collectionsVC, animated: true)
    }
    
    @IBAction func cameraFlipButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NotificationNames.FLIP_CAMERA, object: nil)
    }
}

// MARK: ScrollViewControllerDelegate
extension MainVC: ScrollViewControllerDelegate {
    
    var viewControllers: [UIViewController?] {
        return [friendsVC, bubblesVC, collectionsVC]
    }
    
    var initialViewController: UIViewController {
        return bubblesVC
    }
    
    func scrollViewDidScroll() {
        
        // calculate percentage for animation
        let min: CGFloat = 0
        let max: CGFloat = scrollViewController.pageSize.width
        let x = scrollViewController.scrollView.contentOffset.x
        
        let result = ((x - min) / (max - min)) - 1
        
       navigationView.animate(to: result)
    }
}




import UIKit.UIGestureRecognizerSubclass

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}
