//
//  NoticeOpenTbModel.h
//  NoticeXi
//
//  Created by li lei on 2021/8/6.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeOpenTbModel : NSObject
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *product_id_2;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *cover;

@property (nonatomic, strong) NSString *sn;

@property (nonatomic, strong) NSString *directions;
@property (nonatomic, strong) NSString *skip_url;
@property (nonatomic, strong) NSString *video_val;
@property (nonatomic, strong) NSArray *image_val;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSAttributedString *attser;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSString *note_type;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSAttributedString *sysAttser;
@end

NS_ASSUME_NONNULL_END
