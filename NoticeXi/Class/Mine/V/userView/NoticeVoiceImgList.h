//
//  NoticeVoiceImgList.h
//  NoticeXi
//
//  Created by li lei on 2019/11/28.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceImgList : UIView
@property (nonatomic, strong) NSArray *shareImgArr;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) UIImageView *imgV1;
@property (nonatomic, strong) UIImageView *imgV2;
@property (nonatomic, strong) UIImageView *imgV3;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, assign) NSInteger imageNum;
@end

NS_ASSUME_NONNULL_END
