//
//  NoticeTeamManageMemberModel.h
//  NoticeXi
//
//  Created by li lei on 2023/6/27.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTeamManageMemberModel : NSObject
@property (nonatomic, strong) NSString *manageId;
@property (nonatomic, strong) NSString *mass_id;
@property (nonatomic, strong) NSString *reason_type;//移出原因(1=人身攻击，2=色情暴力，3=共享自拍，4=垃圾广告)
@property (nonatomic, strong) NSString *is_forbid;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *mass_title;
@property (nonatomic, strong) NSDictionary *from_user;
@property (nonatomic, strong) NoticeAbout *fromUserM;
@property (nonatomic, strong) NSDictionary *to_user;
@property (nonatomic, strong) NoticeAbout *toUserM;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, assign) CGFloat reasonHeight;
@end

NS_ASSUME_NONNULL_END
