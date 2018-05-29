//
//  DLPhotoPickerViewController.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/28.
//

import UIKit
import Photos

public class DLPhotoPickerController: UINavigationController {

    let rootVC = DLPhotoPicker()
    
    /// 是否隐藏 StatusBar
    public override var prefersStatusBarHidden: Bool {
        if let topViewController = self.topViewController {
            return topViewController.prefersStatusBarHidden
        } else {
            return Util.hasSafeAreaInsets == false
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init() {
        super.init(rootViewController: rootVC)
        self.delegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DLPhotoPickerController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is DLPhotoPicker && toVC is DLPhotoBrowserController {
            return DLPhotoBrowserControllerAnimator()
        }
        
        return nil
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        print(navigationController.self, toVC.self)
        
        return nil
    }
    
}
