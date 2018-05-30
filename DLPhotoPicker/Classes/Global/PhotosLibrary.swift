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
    
    /// 获取所有照片
    static func fetchDefaultAlbum(withMediaType mediaType: PHAssetMediaType? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> PhotoAlbum {
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

        return PhotoAlbum(title: __("Camera Roll"), assets: assets)
    }
    
    /// 获取所有相册
    static func fetchAllAlbums() -> [PhotoAlbum] {
        var items = [PhotoAlbum]()
        let options = PHFetchOptions()
        let assetOptions = PHFetchOptions()
        assetOptions.sortDescriptors = [descriptor]
        assetOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let assets = PHAsset.fetchAssets(with: assetOptions)
        let allPhotoAlbum = PhotoAlbum(title: __("Camera Roll"), assets: assets)
        items.append(allPhotoAlbum)
        
        // 个人收藏, 最近添加
        var collectionTypes: [PHAssetCollectionSubtype] = [.smartAlbumFavorites, .smartAlbumRecentlyAdded]
        
        if #available(iOS 9.0, *) {
            // 自拍
            collectionTypes.append(.smartAlbumSelfPortraits)
            
            // 截图
            collectionTypes.append(.smartAlbumScreenshots)
            
            // 景深
            if #available(iOS 10.2, *) {
                collectionTypes.append(.smartAlbumDepthEffect)
            }
        }
        
        // 获取系统相册
        for type in collectionTypes {
            if let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: type, options: options).firstObject {
                let album = PhotoAlbum(title: collection.localizedTitle ?? "", assets: self.fetchAssets(collection))
                items.append(album)
            }
        }
        
        // 获取用户相册
        let userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: options)
        userCollections.enumerateObjects { (collection, index, stop) in
            let album = PhotoAlbum(title: collection.localizedTitle ?? "", assets: self.fetchAssets(collection))
            items.append(album)
        }
        
        // 过滤数量为0的相册
        items = items.filter { $0.assets.count > 0 }
        
        return items
    }
    
    //、 获取相册的资源
    static func fetchAssets(_ collection: PHAssetCollection, mediaType: PHAssetMediaType? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        
        if sortDescriptors == nil {
            options.sortDescriptors = [descriptor]
        } else {
            options.sortDescriptors = sortDescriptors
        }
        
        if let mediaType = mediaType {
            options.predicate = NSPredicate(format: "mediaType = %d", mediaType.rawValue)
        }
        
        let assets = PHAsset.fetchAssets(in: collection, options: options)
        return assets
    }
    
    /// 删除指定资源
    static func deleteAsset(asset: PHAsset, completionHandler: ((Bool, Error?) -> Void)? = nil) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)
        }, completionHandler: completionHandler)
    }
    
}
