//
//  NoticeCollectionVoiceController.h
//  NoticeXi
//
//  Created by li lei on 2023/2/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NoticeCollectionVoiceController : UIViewController<NoticeAssestDelegate>
@property (nonatomic, assign) BOOL isSame;//同频域
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL canAutoLoad;
@end

NS_ASSUME_NONNULL_END
