//
//  NoticeEmotionModel.h
//  NoticeXi
//
//  Created by li lei on 2020/10/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeEmotionModel : NSObject
@property (nonatomic, strong) NSString *picture_sort;
@property (nonatomic, strong) NSString *picture_url;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, strong) NSString *bucket_id;
@property (nonatomic, strong) NSString *picture_uri;
@property (nonatomic, strong) NSString *pictureId;
@end

NS_ASSUME_NONNULL_END
