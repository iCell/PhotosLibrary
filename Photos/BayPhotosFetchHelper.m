//
//  BayPhotosFetchHelper.m
//  Photos
//
//  Created by Xiaoyu Li on 08/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import "BayPhotosFetchHelper.h"

@import Photos;

@interface BayPhotosFetchHelper () <PHPhotoLibraryChangeObserver>

@property (strong, nonatomic) PHFetchResult<PHAsset *> *allPhotos;
//@property (strong, nonatomic) PHFetchResult<PHAssetCollection *> *smartAlbums;
//@property (strong, nonatomic) PHFetchResult<PHCollection *> *userCollections;

@end

@implementation BayPhotosFetchHelper

- (void)registerCollectionsChange {
    PHFetchOptions *fetchOption = [[PHFetchOptions alloc] init];
    [fetchOption setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES]]];
    
    self.allPhotos = [PHAsset fetchAssetsWithOptions:fetchOption];
    
//    self.smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    
//    self.userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)unregisterCollectionsChange {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{
        PHFetchResultChangeDetails *allPhotosChangeDetails = [changeInstance changeDetailsForFetchResult:self.allPhotos];
        if (allPhotosChangeDetails) {
            self.allPhotos = [allPhotosChangeDetails fetchResultAfterChanges];
        }
        
//        PHFetchResultChangeDetails *smartAlbumChangeDetails = [changeInstance changeDetailsForFetchResult:self.smartAlbums];
//        if (smartAlbumChangeDetails) {
//            self.smartAlbums = [allPhotosChangeDetails fetchResultAfterChanges];
//        }
//        
//        PHFetchResultChangeDetails *userCollectionsChangeDetails = [changeInstance changeDetailsForFetchResult:self.userCollections];
//        if (userCollectionsChangeDetails) {
//            self.userCollections = [allPhotosChangeDetails fetchResultAfterChanges];
//        }
    });
}

@end