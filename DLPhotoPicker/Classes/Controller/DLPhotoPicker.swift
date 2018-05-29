//
//  DLPhotoPicker.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/28.
//

import UIKit
import Photos

internal class DLPhotoPicker: UIViewController {

    /// 当前相册
    private var currentAlbum = PhotosLibrary.fetchDefaultAlbum() {
        didSet {
            self.albumTitleView.title = self.currentAlbum.title
        }
    }
    
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
    
    /// 相册标题
    private lazy var albumTitleView: AlbumTitleView = {
        let view = AlbumTitleView()
        return view
    }()
    
    /// 退出按钮
    private lazy var closeBarButtonItem = UIBarButtonItem(image: UIImage(asset: "Close"), style: .plain, target: self, action: #selector(didTapCloseButton(sender:)))

    /// 相册选择控制器是否已显示
    private var isAlbumPickerShowing = false
    
    /// 相册选择控制器
    private lazy var albumPickerVC = DLAlbumPickerController()
    
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
    
    /// 转场图片
    var didSelectImage: UIImage?
    
    /// 转场位置
    var transitionStartFrame: CGRect?
    
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
        self.albumPickerVC.view.frame = self.view.bounds
    }
    
}

// MARK: - CollectionView
extension DLPhotoPicker: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentAlbum.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetCell", for: indexPath) as! DLPhotoPickerCollectionViewCell
        
        let index = indexPath.item
        if index >= 0 && index < self.currentAlbum.assets.count {
            let asset = self.currentAlbum.assets[index]
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
        if index >= 0 && index < self.currentAlbum.assets.count {
            let cell = self.collectionView.cellForItem(at: indexPath) as! DLPhotoPickerCollectionViewCell
            self.didSelectImage = cell.thumbnailImageView.image
            self.transitionStartFrame = CGRect(x: cell.frame.minX,
                                               y: cell.frame.minY + self.navigationController!.navigationBar.bounds.height + Util.safeAreaInsets.top,
                                               width: cell.frame.width,
                                               height: cell.frame.height)
            
            let browserVC = DLPhotoBrowserController(assets: self.currentAlbum.assets, currentIndex: index)
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
 
    /// 点击相册标题
    func didTapAlbumTitleView() {
        if self.isAlbumPickerShowing == false {
            self.albumPickerVC.showAlbumPicker()
        } else {
            self.albumPickerVC.hideAlbumPicker()
        }
        
        self.isAlbumPickerShowing = !self.isAlbumPickerShowing
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
        
        self.albumTitleView.title = self.currentAlbum.title
        self.albumTitleView.clickHandler = { [unowned self] in
            self.didTapAlbumTitleView()
        }
        self.navigationItem.titleView = self.albumTitleView
    }
    
    /// 初始化 UI
    func setupUI() {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.collectionView)
        
        // 相册选择
        self.addChildViewController(self.albumPickerVC)
        self.albumPickerVC.view.isHidden = true
        self.view.addSubview(self.albumPickerVC.view)
        
        self.albumPickerVC.selectAlbumHandler = { [unowned self] (album) in
            self.albumPickerVC.hideAlbumPicker()
            self.isAlbumPickerShowing = false
            
            if self.currentAlbum.assets.count > 0 {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
            
            self.currentAlbum = album
            self.collectionView.reloadData()
        }
    }

}


