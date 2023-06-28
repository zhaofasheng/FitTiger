//
//  NoticeTieTieModel.h
//  NoticeXi
//
//  Created by li lei on 2022/4/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTieTieModel : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *number;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cover_url;

@property (nonatomic, strong) NSArray *sign_list;
@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, strong) NSDictionary *past_info;
@property (nonatomic, strong) NoticeTieTieModel *pastModel;

@property (nonatomic, strong) NSDictionary *future_info;
@property (nonatomic, strong) NoticeTieTieModel *futureModel;

@property (nonatomic, strong) NSString *continuity_days;
@property (nonatomic, strong) NSString *continuity_text;
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;

@property (nonatomic, strong) NSString *is_sign;

@end

NS_ASSUME_NONNULL_END
