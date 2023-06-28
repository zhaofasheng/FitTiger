//
//  NoticeBackQustionModel.h
//  NoticeXi
//
//  Created by li lei on 2021/1/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeBackQustionModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSAttributedString *contentAtt;
@property (nonatomic, strong) NSAttributedString *contentSmallAtt;
@end

NS_ASSUME_NONNULL_END
