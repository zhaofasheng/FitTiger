//
//  NoticeTestLy.h
//  NoticeXi
//
//  Created by li lei on 2019/2/1.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTestLyModel : NSObject

@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *lyId;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSMutableAttributedString *attString;
@property (nonatomic, strong) NSString *personality_title;
@property (nonatomic, strong) NSString *personality_no;
@property (nonatomic, assign) BOOL isT;
@end

NS_ASSUME_NONNULL_END
