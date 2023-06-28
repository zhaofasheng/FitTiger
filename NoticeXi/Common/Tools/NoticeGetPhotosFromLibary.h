//
//  NoticeGetPhotosFromLibary.h
//  NoticeXi
//
//  Created by li lei on 2020/12/29.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBackQustionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeGetPhotosFromLibary : UIView
+ (NSMutableArray *)getOnlyPhotos;
+ (NSMutableArray *)getPhotos;
+ (NSMutableArray *)getTextArr;
@end

NS_ASSUME_NONNULL_END
