//
//  NoticeDanMuListModel.h
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeDanMuListModel : NSObject
@property (nonatomic, strong) NSString *barrage_at;
@property (nonatomic, strong) NSString *barrageTime;
@property (nonatomic, strong) NSString *barrage_colour;
@property (nonatomic, strong) NSString *barrage_content;
@property (nonatomic, strong) NSString *barrage_likes;
@property (nonatomic, strong) NSString *barrage_position;
@property (nonatomic, strong) NSString *content_type;
@property (nonatomic, strong) NSString *podcast_no;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *danmuId;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NoticeAbout *userM;
@property (nonatomic, strong) NSString *is_likes;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *cover_url;

@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat textWidth;
@property (nonatomic, strong) NSAttributedString *attStr;

//以下字段管理员专用
@property (nonatomic, strong) NSString *podcast_id;//播客id
@property (nonatomic, strong) NSString *podcast_status;//审核状态(1正常2删除3代表已下架)
@property (nonatomic, strong) NSString *role;//播客作者状态(0正常 1白名单 2黑名单)
@end

NS_ASSUME_NONNULL_END
