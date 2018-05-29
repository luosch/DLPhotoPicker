//
//  PhotosLibrary.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/28.
//

import UIKit
import Photos

internal struct AlbumItem {
    /// 相册标题
    var title: String
    /// 相册资源
    var fetchResult: PHFetchResult<PHAsset>
}

internal class PhotosLibrary: NSObject {

    /// 排序方法
    static private let descriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    
    /// 获取所有资源
    static func fetchAssets(withMediaType mediaType: PHAssetMediaType? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> PHFetchResult<PHAsset> {
        let assetOptions = PHFetchOptions()
        if sortDescriptors == nil {
            assetOptions.sortDescriptors = [PhotosLibrary.descriptor]
        } else {
            assetOptions.sortDescriptors = sortDescriptors
        }
        
        if let mediaType = mediaType {
            assetOptions.predicate = NSPredicate(format: "mediaType = %d", mediaType.rawValue)
        }
        
        let assets = PHAsset.fetchAssets(with: assetOptions)

        return assets
    }
    
}
