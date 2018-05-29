//
//  PhotoAlbum.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/29.
//

import UIKit
import Photos

class PhotoAlbum: NSObject {
    
    /// 相册标题
    var title: String
    /// 相册资源
    var assets: PHFetchResult<PHAsset>

    init(title: String, assets: PHFetchResult<PHAsset>) {
        self.title = title
        self.assets = assets
        
        super.init()
    }
    
}
