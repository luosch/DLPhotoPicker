import UIKit

class ZoomOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let duration: TimeInterval = 0.3
    
    override init() {
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PhotoBrowserController  else {
            self.animateTransitionNormally(using: transitionContext)
            return
        }
        
        guard let toVC = transitionContext.viewController(forKey: .to) as? PhotoPicker else {
            self.animateTransitionNormally(using: transitionContext)
            return
        }
        
        guard let image = fromVC.currentCell?.imageView.image, let _ = fromVC.currentCell?.frame, let endFrame = toVC.transitionStartFrame  else {
            self.animateTransitionNormally(using: transitionContext)
            return
        }

        fromVC.hideCollectionView()
        
        let containerView = transitionContext.containerView
        toVC.view.alpha = 0.0
        containerView.addSubview(toVC.view)
        
        let startFrame: CGRect
        if image.size.width / image.size.height > containerView.bounds.width / containerView.bounds.height {
            let height = containerView.bounds.width * image.size.height / image.size.width
            startFrame = CGRect(x: 0.0,
                                y: (containerView.bounds.height - height) * 0.5,
                                width: containerView.bounds.width,
                                height: height)
        } else {
            let width = containerView.bounds.height * image.size.width / image.size.height
            startFrame = CGRect(x: (containerView.bounds.width - width) * 0.5,
                                y: 0.0,
                                width: width,
                                height: containerView.bounds.height)
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = startFrame
        containerView.addSubview(imageView)
        
        UIView.animate(withDuration: self.duration, animations: {
            toVC.view.alpha = 1.0
            imageView.frame = endFrame
        }) { (success) in
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    /// 正常过渡
    func animateTransitionNormally(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if let view = transitionContext.view(forKey: .to) {
            view.alpha = 0.0
            containerView.addSubview(view)
            
            UIView.animate(withDuration: self.duration, animations: {
                view.alpha = 1.0
            }) { (success) in
                transitionContext.completeTransition(true)
            }
        } else {
            transitionContext.completeTransition(true)
        }
        
        transitionContext.completeTransition(true)
    }
    
}
