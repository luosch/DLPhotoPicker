import UIKit
import Photos

internal class PhotoBrowserController: UIViewController {

    /// 当前资源列表
    private var assets: PHFetchResult<PHAsset>
    
    /// 当前图片序号
    private var currentIndex: Int {
        didSet {
            self.currentIndexChangeHandler?(self.currentIndex)
            self.navigationItem.title = String(format: "%d / %d", self.currentIndex+1, self.assets.count)
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
    
    /// 返回按钮
    private lazy var backBarButtonItem = UIBarButtonItem(image: UIImage(asset: "Back"), style: .plain, target: self, action: #selector(didTapBackButton(sender:)))
    
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
        view.backgroundColor = UIColor.white
        return view
    }()
    
    /// 底部 Bar
    private lazy var bottomBar = PhotoBrowserBottomBar()
    
    /// 转场Cell
    var currentCell: PhotoBrowserCollectionViewCell? {
        if let cell = self.collectionView.cellForItem(at: IndexPath(item: self.currentIndex, section: 0)) as? PhotoBrowserCollectionViewCell {
            return cell
        } else {
            return nil
        }
    }
    
    /// 是否隐藏 StatusBar
    override var prefersStatusBarHidden: Bool {
        if Util.hasSafeAreaInsets {
            return false
        } else {
            return true
        }
    }
    
    /// 改变图片序号回调
    var currentIndexChangeHandler: ((Int) -> Void)?
    
    /// 初始化
    ///
    /// - Parameter assets: 资源
    init(assets: PHFetchResult<PHAsset>, currentIndex: Int) {
        self.assets = assets
        self.currentIndex = currentIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.setupUI()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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
        
        self.bottomBar.frame = CGRect(x: 0.0,
                                      y: self.view.bounds.height - 46.0 - Util.safeAreaInsets.bottom,
                                      width: self.view.bounds.width,
                                      height: 46.0)
        
//        let currentIndex = self.currentIndex
//        self.currentIndex = currentIndex
        let indexPath = IndexPath(item: self.currentIndex, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
}

// MARK: - Button events
private extension PhotoBrowserController {
    
    @objc func didTapBackButton(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Transtion
extension PhotoBrowserController {
 
    func showCollectionView() {
        self.collectionView.isHidden = false
    }

    func hideCollectionView() {
        self.collectionView.isHidden = true
    }
    
}

// MARK: - CollectionView
extension PhotoBrowserController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newIndex = Int(scrollView.contentOffset.x / self.collectionView.frame.size.width)
        self.currentIndex = max(0, min(newIndex, self.assets.count-1))
    }
    
}

// MARK: - Photos Obsever
extension PhotoBrowserController: PHPhotoLibraryChangeObserver {

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let detail = changeInstance.changeDetails(for: self.assets) {
                self.assets = detail.fetchResultAfterChanges
                
    //            if self.currentIndex < 0 {
    //                self.currentIndex = 0
    //            }
    //
    //            if self.currentIndex > self.assets.count - 1 {
    //                self.currentIndex = self.assets.count - 1
    //            }
                
                let currentIndex = max(0, min(self.currentIndex, self.assets.count - 1))
                self.currentIndex = currentIndex
                
    //            self.currentIndexPath = IndexPath(item: index, section: 0)
    //            self.collectionViewScrolledCallback?(self.currentIndexPath!)
    //            self.collectionView.reloadItems(at: [self.currentIndexPath!])
    //            let cell = self.collectionView.cellForItem(at: self.currentIndexPath!) as! PhotoBrowserCollectionViewCell
    //            self.cell = cell
    //            self.transitionIndexPath = self.currentIndexPath

                self.collectionView.reloadData()
            
                let indexPath = IndexPath(item: self.currentIndex, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
}

// MARK: - Private
private extension PhotoBrowserController {
    
    /// 初始化导航栏
    func setupNavBar() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(hex: 0xffffff, alpha: 0.5)), for: .default)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem
        
        self.navigationItem.title = String(format: "%d / %d", self.currentIndex+1, self.assets.count)
    }
    
    /// 初始化 UI
    func setupUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.collectionView)
        
        self.view.addSubview(self.bottomBar)
        self.bottomBar.deleteHandler = { [unowned self] in
            if self.currentIndex >= 0 && self.currentIndex < self.assets.count {
                let asset = self.assets[self.currentIndex]
                PhotosLibrary.deleteAsset(asset: asset)
            }
        }
    }
    
}

