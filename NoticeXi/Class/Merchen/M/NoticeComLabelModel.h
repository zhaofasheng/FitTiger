//
//  NoticeComLabelModel.h
//  NoticeXi
//
//  Created by li lei on 2023/4/16.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeComLabelModel : NSObject
@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, strong) NSString *labelId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *showStr;
@property (nonatomic, assign) CGFloat showStrWidth;
@end

NS_ASSUME_NONNULL_END
