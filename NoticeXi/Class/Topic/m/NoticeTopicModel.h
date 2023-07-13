//
//  NoticeTopicModel.h
//  NoticeXi
//
//  Created by li lei on 2018/10/31.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTopicModel : NSObject
@property (nonatomic, strong) NSString *topic_id;
@property (nonatomic, strong) NSString *loveId;
@property (nonatomic, strong) NSString * __nullable topic_name;
@property (nonatomic, strong) NSString *voice_num;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *keyTitle;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *artwork_num;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *http_img_url;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, strong) NSAttributedString *fiveAttTextStr;
@property (nonatomic, assign) BOOL isMoreFiveLines;//是否超过五行文字
@property (nonatomic, assign) CGFloat fiveTextHeight;//五行文字高度
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSString *showText;
@property (nonatomic, strong) NSString *num;
@end

NS_ASSUME_NONNULL_END
