//
//  NoticeDanMuModel.h
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceSaveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDanMuModel : NSObject
@property (nonatomic, strong) NoticeVoiceSaveModel *saveModel;
@property (nonatomic, strong) NSString *audio_url;
@property (nonatomic, strong) NSString *background_url;
@property (nonatomic, strong) NSString *cover_url;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *podcast_intro;
@property (nonatomic, assign) CGFloat introeHeight;
@property (nonatomic, strong) NSString *podcast_no;
@property (nonatomic, strong) NSString *podcast_title;
@property (nonatomic, strong) NSString *bokeId;
@property (nonatomic, strong) NSString *total_time;
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSAttributedString *allTitleAttStr;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, strong) NSString *is_hot;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *count_like;
@property (nonatomic, strong) NSString *is_podcast_like;
@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, assign) BOOL isSaveInDocum;//来自于缓存
@property (nonatomic, strong) NSString *pageNo;
@property (nonatomic, strong) NSString *allNum;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSString *sendAt;
@property (nonatomic, strong) NSString *podcast_type;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *podcast_status;//审核状态(1正常2删除3代表已下架)
@end

NS_ASSUME_NONNULL_END
