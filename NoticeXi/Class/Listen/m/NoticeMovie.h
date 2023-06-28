//
//  NoticeMovie.h
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceModel.h"
@interface NoticeMovie : NSObject

@property (nonatomic, strong) NSString *movie_id;
@property (nonatomic, strong) NSString *movie_title;
@property (nonatomic, strong) NSArray *movie_type;
@property (nonatomic, strong) NSString *movietype;
@property (nonatomic, strong) NSString *editMovieType;
@property (nonatomic, strong) NSString *movie_poster;
@property (nonatomic, strong) NSArray *movie_starring;
@property (nonatomic, strong) NSString *movieStar;
@property (nonatomic, strong) NSString *movie_len;
@property (nonatomic, strong) NSString *movie_score;
@property (nonatomic, strong) NSString *released_at;
@property (nonatomic, strong) NSString *released_date;
@property (nonatomic, strong) NSString *releasedYear;
@property (nonatomic, strong) NSArray *movie_area;
@property (nonatomic, strong) NSString *movieAdress;
@property (nonatomic, assign) BOOL isMoreLines;//是否超过五行文字
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSAttributedString *fiveAttTextStr;
@property (nonatomic, assign) CGFloat fiveTextHeight;//五行文字高度
@property (nonatomic, strong) NSString *movie_intro;
@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *user_score;
@property (nonatomic, strong) NSString *area_name;

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *movieListId;

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *voice_id;
@property (nonatomic, strong) NSString *rate_id;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, strong) NSDictionary *subscription;
@property (nonatomic, strong) NSString * __nullable subscription_type;
@property (nonatomic, strong) NSString * __nullable subscription_id;//订阅ID
@property (nonatomic, strong) NSDictionary * __nullable first_voice;
@property (nonatomic, strong) NoticeVoiceModel * __nullable voiceM;
@property (nonatomic, strong) NSString * _Nullable voice_num;
@property (nonatomic, strong) NSDictionary *__nullable resource;

@end


