//
//  NoticeWriteRecodModel.h
//  NoticeXi
//
//  Created by li lei on 2021/12/8.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeLy.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeWriteRecodModel : NSObject
@property (nonatomic, strong) NSString *bannerId;
@property (nonatomic, strong) NSMutableArray *lyArr;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSString *attr_pc_url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *taketed_at;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *show_type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *cover_url;
@property (nonatomic, strong) NSString *is_like;
@property (nonatomic, strong) NSString *like_num;
@end

NS_ASSUME_NONNULL_END
