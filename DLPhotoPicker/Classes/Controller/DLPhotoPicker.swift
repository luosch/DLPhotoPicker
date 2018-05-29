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
    
    /// 图片请求选项
    fileprivate lazy var options: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        return options
    }()
    
    /// 中间间隔大小
    private let intervalInset: CGFloat = 1.0
    
    /// 缩略图大小
    private lazy var thumbnailSize: CGSize = {
        let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let width = floor((screenWidth - self.intervalInset*2.0) / 3.0) * UIScreen.main.scale
        return CGSize(width: width, height: width)
    }()
    
    /// Cell 大小
    private lazy var itemSize: CGSize = {
        let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let width = floor((screenWidth - self.intervalInset*2.0) / 3.0)
        return CGSize(width: width, height: width)
    }()
    
    /// 退出按钮
    private lazy var closeBarButtonItem = UIBarButtonItem(image: UIImage(asset: "Close"), style: .plain, target: self, action: #selector(didTapCloseButton(sender:)))

    /// 照片集合视图布局
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.itemSize
        layout.sectionInset = UIEdgeInsets(top: 3.0, left: 0.0, bottom: 4.0, right: 0.0)
        layout.minimumLineSpacing = self.intervalInset
        layout.minimumInteritemSpacing = self.intervalInset
        return layout
    }()
    
    /// 照片集合视图
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
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
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.frame = self.view.bounds
    }
    
}

// MARK: - CollectionView
extension DLPhotoPicker: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetCell", for: indexPath) as! DLPhotoPickerCollectionViewCell
        
        let index = indexPath.item
        if index >= 0 && index < self.assets.count {
            let asset = self.assets[index]
            self.imageManager.requestImage(for: asset, targetSize: self.thumbnailSize, contentMode: .aspectFill, options: self.options) { (image, info) in
                DispatchQueue.main.async {
                    cell.thumbnailImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let index = indexPath.item
        if index >= 0 && index < self.assets.count {
            let asset = self.assets[index]
            let browserVC = DLPhotoBrowserController(assets: assets, currentIndex: index)
            self.navigationController?.pushViewController(browserVC, animated: true)
        }
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
    
    /// 初始化导航栏
    func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor(hex: 0x333333)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = self.closeBarButtonItem
    }
    
    /// 初始化 UI
    func setupUI() {
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
        
        self.view.addSubview(self.collectionView)
    }
    
}


