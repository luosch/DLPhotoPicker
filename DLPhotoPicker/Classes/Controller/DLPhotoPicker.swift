//
//  DLPhotoPicker.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/28.
//

import UIKit
import Photos

internal class DLPhotoPicker: UIViewController {

    /// 当前资源列表
    private var assets = PhotosLibrary.fetchAssets()
    
    /// 图片管理器
    private let imageManager = PHCachingImageManager()
    
    private let thumbnailSize: CGFloat = {
        let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }()
    
    /// 退出按钮
    private lazy var closeBarButtonItem = UIBarButtonItem(image: UIImage(asset: "Close"), style: .plain, target: self, action: #selector(didTapCloseButton(sender:)))

    /// 照片集合视图
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DLPhotoPickerCollectionViewCell.self, forCellWithReuseIdentifier: "AssetCell")
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        return collectionView
    }()
    
    /// 是否隐藏 StatusBar
    override var prefersStatusBarHidden: Bool {
        return Util.hasSafeAreaInsets == false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar()
        self.setupUI()
        
        print("assets.count", assets.count)
    }

}

extension DLPhotoPicker: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetCell", for: indexPath) as! DLPhotoPickerCollectionViewCell
        
        self.imageManager.requestImage(for: <#T##PHAsset#>, targetSize: <#T##CGSize#>, contentMode: <#T##PHImageContentMode#>, options: <#T##PHImageRequestOptions?#>, resultHandler: <#T##(UIImage?, [AnyHashable : Any]?) -> Void#>)
        
        return cell
    }
    
}

// MARK: - Button events
private extension DLPhotoPicker {
    
    /// 点击退出按钮
    @objc func didTapCloseButton(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Private
private extension DLPhotoPicker {
    
    /// 初始化 UI
    func setupUI() {
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    /// 初始化导航栏
    func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor(hex: 0x333333)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = self.closeBarButtonItem
    }
    
}


