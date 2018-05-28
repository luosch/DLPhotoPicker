//
//  ViewController.swift
//  DLPhotoPicker
//
//  Created by luosch on 05/28/2018.
//  Copyright (c) 2018 luosch. All rights reserved.
//

import UIKit
import SnapKit
import DLPhotoPicker

class ViewController: UIViewController {

    lazy var albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open Album", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapAlbumButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.albumButton)
        self.albumButton.snp.makeConstraints { make in
            make.width.equalTo(200.0)
            make.height.equalTo(44.0)
            make.center.equalToSuperview()
        }
    }

    @objc func didTapAlbumButton(sender: UIButton) {
//                let picker = UIImagePickerController()
        let photoPicker = DLPhotoPickerController()
        self.present(photoPicker, animated: true, completion: nil)
    }
    
}

