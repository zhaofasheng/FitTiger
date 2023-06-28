//
//  NoticeHelpListModel.h
//  NoticeXi
//
//  Created by li lei on 2022/8/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeHelpListModel : NSObject
@property (nonatomic, strong) NSString *tieId;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;

@property (nonatomic, strong) NSString *reply_num;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) NSAttributedString *fiveAttTextStr;
@property (nonatomic, assign) BOOL isMoreFiveLines;//是否超过五行文字
@property (nonatomic, assign) CGFloat fiveTextHeight;//五行文字高度
@property (nonatomic, assign) CGFloat textBetwonHeight;//多出的文字高度
@property (nonatomic, assign) CGFloat fiveBetTextHeight;//五行文字cell高度
@property (nonatomic, strong) NSString *showText;
@property (nonatomic, assign) CGFloat allTextHeight;
@property (nonatomic, strong) NSString *is_dislike;
//求助帖最新，最热模块
@property (nonatomic, strong) NSArray *recent_invitation;
@property (nonatomic, strong) NSDictionary *hot_invitation;
@property (nonatomic, strong) NSString *proposeHotNum;//最热建议人数
@property (nonatomic, strong) NSString *proposeNum;//最新建议人数
@property (nonatomic, strong) NSDictionary *giveData;//最新点赞最多数据
@property (nonatomic, strong) NoticeAbout *giveModel;
@property (nonatomic, strong) NSDictionary *giveHotData;//最热点赞最多数据
@property (nonatomic, strong) NoticeAbout *giveHotModel;
@property (nonatomic, strong) NSArray *recentData;
@property (nonatomic, strong) NSArray *hotRecentData;

@property (nonatomic, strong) NSDictionary *user_info;
@property (nonatomic, strong) NoticeAbout *userM;
@property (nonatomic, strong) NSArray *img_list;
@end

NS_ASSUME_NONNULL_END
