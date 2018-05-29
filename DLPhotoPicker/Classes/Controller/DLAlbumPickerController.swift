//
//  DLAlbumPickerController.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/29.
//

import UIKit
import Photos

internal class DLAlbumPickerController: UIViewController {

    /// 所有相册
    private var allAlbums = [PhotoAlbum]()
    
    /// 相册 Cell 高度
    private var albumCellHeight: CGFloat = 50.0
    
    /// 集合视图
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DLAlbumTableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    /// 选择相册回调
    var selectAlbumHandler: ((PhotoAlbum) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAllAlbums()
        self.setupUI()
    }
 
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
}

// MARK: - Animation
extension DLAlbumPickerController {
    
    /// 显示相册选择
    func showAlbumPicker() {
        self.view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        
        self.view.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.tableView.frame = CGRect(x: 0.0,
                                          y: 0.0,
                                          width: self.view.bounds.width,
                                          height: self.albumCellHeight * 6.5)
        }
        
        self.tableView.reloadData()
    }
    
    /// 隐藏相册选择
    func hideAlbumPicker() {
        self.view.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.frame = CGRect(x: 0.0,
                                          y: -(self.albumCellHeight * 6.5),
                                          width: self.view.bounds.width,
                                          height: self.albumCellHeight * 6.5)
        }) { (success) in
            self.view.isHidden = true
        }
    }
    
}

// MARK: - TableView
extension DLAlbumPickerController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allAlbums.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.albumCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! DLAlbumTableViewCell
        
        let index = indexPath.item
        
        if index >= 0 && index < self.allAlbums.count {
            let album = self.allAlbums[index]
            
            DispatchQueue.main.async {
                cell.titleLabel.text = album.title
                cell.countLabel.text = String(format: "%d", album.assets.count)
            }
            
            if let asset = album.assets.firstObject {
                let imageManager = PHImageManager.default()
                let options = PHImageRequestOptions()
                options.deliveryMode = .opportunistic
                
                let size = CGSize(width: self.albumCellHeight * UIScreen.main.scale,
                                  height: self.albumCellHeight * UIScreen.main.scale)
                
                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = image
                    }
                })
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath.item
        if index >= 0 && index < self.allAlbums.count {
            let album = self.allAlbums[index]
            self.selectAlbumHandler?(album)
        }
    }
    
}

// MARK: - Private
private extension DLAlbumPickerController {
    
    /// 初始化 UI
    func setupUI() {
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.tableView)
        self.tableView.frame = CGRect(x: 0.0,
                                      y: -(self.albumCellHeight * 6.5),
                                      width: self.view.bounds.width,
                                      height: self.albumCellHeight * 6.5)
    }
    
    /// 初始化所有相册
    func setupAllAlbums() {
        self.allAlbums = PhotosLibrary.fetchAllAlbums()
    }
}
