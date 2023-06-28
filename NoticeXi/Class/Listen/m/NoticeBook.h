//
//  NoticeBook.h
//  NoticeXi
//
//  Created by li lei on 2019/4/18.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceModel.h"
#import <CoreText/CoreText.h>
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBook : NSObject
@property (nonatomic, strong) NSString *book_author;//书籍作者
@property (nonatomic, strong) NSString *book_cover;//书籍封面地址
@property (nonatomic, strong) NSString *book_intro;//书籍简介
@property (nonatomic, assign) BOOL isMoreLines;//是否超过五行文字
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSAttributedString *fiveAttTextStr;
@property (nonatomic, assign) CGFloat fiveTextHeight;//五行文字高度
@property (nonatomic, strong) NSString *book_isbn;//书籍ISBN
@property (nonatomic, strong) NSString *book_name;//书籍名称
@property (nonatomic, strong) NSString *book_publisher;//书籍出版社
@property (nonatomic, strong) NSString *book_score;//书籍评分
@property (nonatomic, strong) NSString *published_date;//出版时间
@property (nonatomic, strong) NSString *bookId;//出版时间
@property (nonatomic, strong) NSString *rate_id;
@property (nonatomic, strong) NSString *book_id;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSDictionary *subscription;
@property (nonatomic, strong) NSString * __nullable subscription_type;
@property (nonatomic, strong) NSString * __nullable subscription_id;//订阅ID
@property (nonatomic, strong) NSString * _Nullable voice_num;
@property (nonatomic, strong) NSDictionary *__nullable resource;
@property (nonatomic, strong) NSDictionary *first_voice;
@property (nonatomic, strong) NoticeVoiceModel *voiceM;
@end

NS_ASSUME_NONNULL_END
