//
//  NoticeSkinModel.h
//  NoticeXi
//
//  Created by li lei on 2021/9/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSkinModel : NSObject
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *defaultImg;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *svg_url;
@property (nonatomic, strong) NSString *skinId;
@property (nonatomic, strong) NSString *is_unlock;
@property (nonatomic, strong) NSString *is_own;
@property (nonatomic, strong) NSString *is_set;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *is_default;
@property (nonatomic, strong) NSString *skin_url;
@end

NS_ASSUME_NONNULL_END
