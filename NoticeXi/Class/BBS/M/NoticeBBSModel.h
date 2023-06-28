//
//  NoticeBBSModel.h
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeAnnexsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBBSModel : NSObject
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *year;

@property (nonatomic, strong) NSString *draft_title;
@property (nonatomic, strong) NSString *draft_content;
@property (nonatomic, strong) NSString *post_id;//帖子ID，0:没有被采纳为帖子
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *textContent;

@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, strong) NSAttributedString *titleAttStr;

@property (nonatomic, strong) NSString *contribution_id;
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, strong) NSAttributedString *twoTextAttStr;

@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat twoLineHeight;
@property (nonatomic, strong) NSString *draft_from;
@property (nonatomic, strong) NSDictionary *from_user_info;
@property (nonatomic, strong) NoticeAbout *userInfo;
@property (nonatomic, strong) NSString *cagaoId;
@property (nonatomic, strong) NSMutableArray *annexsArr;
@property (nonatomic, strong) NSArray *annexs;
@property (nonatomic, strong) NSMutableArray *imgListArr;

@property (nonatomic, assign) CGFloat imgHeight;

//帖子
@property (nonatomic, strong) NSString *post_title;//当存在这个的时候，cagaoId是帖子id
@property (nonatomic, strong) NSString *post_sort;
@property (nonatomic, strong) NSString *reply_num;
@property (nonatomic, strong) NSString *post_content;
@property (nonatomic, strong) NSString *comment_num;
@property (nonatomic, strong) NSAttributedString *fiveAttTextStr;
@property (nonatomic, assign) BOOL isMoreFiveLines;//是否超过五行文字
@property (nonatomic, assign) CGFloat fiveTextHeight;//五行文字高度

@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *commentArr;
@end

NS_ASSUME_NONNULL_END
