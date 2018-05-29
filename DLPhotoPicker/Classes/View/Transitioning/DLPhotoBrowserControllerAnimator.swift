//
//  DLPhotoBrowserControllerAnimator.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/29.
//

import UIKit

internal class DLPhotoBrowserControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.3
    
    override init() {
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? DLPhotoPicker else {
            transitionContext.completeTransition(true)
            return
        }
        
        guard let toVC = transitionContext.viewController(forKey: .to) as? DLPhotoBrowserController else {
            transitionContext.completeTransition(true)
            return
        }
        
        guard let image = fromVC.didSelectImage, let startFrame = fromVC.transitionStartFrame else {
            transitionContext.completeTransition(true)
            return
        }
        
        print(startFrame)
//        print(fromVC.didSelectImage, fromVC.transitionStartFrame)
        
        let containerView = transitionContext.containerView
        toVC.view.alpha = 0.0
        containerView.addSubview(toVC.view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = startFrame
        
        containerView.addSubview(imageView)
        
        UIView.animate(withDuration: 2.0, animations: {
            toVC.view.alpha = 1.0
        }) { (success) in
            transitionContext.completeTransition(true)
        }
        
        
//        fromVC.view.isHidden = true
    }
    
}
