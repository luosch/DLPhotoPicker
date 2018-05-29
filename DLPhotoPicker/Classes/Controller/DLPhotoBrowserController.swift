//
//  DLPhotoBrowserController.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/29.
//

import UIKit
import Photos

internal class DLPhotoBrowserController: UIViewController {

    /// 当前资源列表
    private var assets: PHFetchResult<PHAsset>
    
    /// 当前图片序号
    private var currentIndex: Int {
        didSet {
            let indexPath = IndexPath(item: self.currentIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    /// 图片管理器
    private let imageManager = PHCachingImageManager()
    
    /// 图片请求选项
    private lazy var options: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        return options
    }()
    
    /// 图片大小
    fileprivate lazy var thumbnailSize: CGSize = {
        var size = UIScreen.main.bounds.size
        size = CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale)
        return size
    }()
    
    /// 集合视图布局
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = UIScreen.main.bounds.size
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return layout
    }()
    
    /// 集合视图
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.register(PhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: "BrowserCell")
        view.backgroundColor = UIColor(hex: 0xF5F5F5)
        return view
    }()
    
    /// 是否隐藏 StatusBar
    override var prefersStatusBarHidden: Bool {
        if Util.hasSafeAreaInsets {
            return false
        } else {
            return true
        }
    }
    
    /// 初始化
    ///
    /// - Parameter assets: 资源
    init(assets: PHFetchResult<PHAsset>, currentIndex: Int) {
        self.assets = assets
        self.currentIndex = currentIndex
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        let inset = Util.safeAreaInsets
//        self.view.frame = CGRect(x: inset.left,
//                                 y: inset.top,
//                                 width: UIScreen.main.bounds.width - inset.left - inset.right,
//                                 height: UIScreen.main.bounds.height - inset.top - inset.bottom)
//
        self.view.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height
        )
        
        self.collectionView.frame = CGRect(
            x: -10.0,
            y: 0.0,
            width: self.view.bounds.width + 20.0,
            height: self.view.bounds.height
        )
        
        let currentIndex = self.currentIndex
        self.currentIndex = currentIndex
    }
    
}

// MARK: - Transtion
extension DLPhotoBrowserController: UIViewControllerTransitioningDelegate {
 
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DLPhotoBrowserControllerAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DLPhotoBrowserControllerAnimator()
    }
    
}

// MARK: - CollectionView
extension DLPhotoBrowserController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowserCell", for: indexPath) as! PhotoBrowserCollectionViewCell
        
        let index = indexPath.item
        if index >= 0 && index < self.assets.count {
            let asset = self.assets[index]
            
            self.imageManager.requestImage(for: asset, targetSize: self.thumbnailSize, contentMode: .aspectFit, options: self.options) { (image, info) in
                if let image = image {
                    cell.imageView.image = image
                }
            }
        }
        
        return cell
    }
    
    
}

// MARK: - Private
private extension DLPhotoBrowserController {
    
    /// 初始化 UI
    func setupUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.collectionView)
    }
    
}

