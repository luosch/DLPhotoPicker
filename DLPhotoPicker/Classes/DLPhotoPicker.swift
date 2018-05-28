//
//  DLPhotoPicker.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/28.
//

import UIKit

class DLPhotoPicker: UIViewController {

    lazy var closeBarButtonItem = UIBarButtonItem(image: UIImage(asset: "Close"), style: .plain, target: self, action: #selector(didTapCloseButton(sender:)))
    
    override var prefersStatusBarHidden: Bool {
        // TODO: iPhoneX
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar()
        self.setupUI()
    }

}

// MARK: - Private
private extension DLPhotoPicker {
    
    func setupUI() {
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor(hex: 0x333333)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = self.closeBarButtonItem
    }
    
}

// MARK: - Button events
private extension DLPhotoPicker {
    
    @objc func didTapCloseButton(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
