//
//  NoticeHasSupportHelpModel.h
//  NoticeXi
//
//  Created by li lei on 2023/5/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeHasSupportHelpModel : NSObject
@property (nonatomic, strong) NSString *tieId;
@property (nonatomic, strong) NSString *title;//帖子标题
@property (nonatomic, strong) NSString *user_id;//帖子作者id
@property (nonatomic, strong) NSString *content;//帖子内容
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSArray *reply_list;
@property (nonatomic, strong) NSMutableArray *replyModelArr;
@end

NS_ASSUME_NONNULL_END
