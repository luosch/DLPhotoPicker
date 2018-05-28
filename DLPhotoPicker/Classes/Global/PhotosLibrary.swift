//
//  PhotosLibrary.swift
//  DLPhotoPicker
//
//  Created by lsc on 2018/5/28.
//

import UIKit
import Photos

internal class PhotosLibrary: NSObject {

    /// 排序方法
    static private let descriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    
    /// 获取资源
    static func fetchAssets(withMediaType mediaType: PHAssetMediaType? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> PHFetchResult<PHAsset>  {
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
