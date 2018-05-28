//
//  DLPhotoPickerCollectionViewCell.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/28.
//

import UIKit

internal class DLPhotoPickerCollectionViewCell: UICollectionViewCell {
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.thumbnailImageView.frame = self.contentView.bounds
    }
    
    func setupUI() {
        self.contentView.addSubview(self.thumbnailImageView)
    }
    
}
