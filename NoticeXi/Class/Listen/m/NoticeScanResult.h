//
//  NoticeScanResult.h
//  NoticeXi
//
//  Created by li lei on 2020/7/1.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeScanResult : NSObject
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *images_large;
@property (nonatomic, strong) NSString *title;
@end

NS_ASSUME_NONNULL_END
