//
//  NoticeZjDialogModel.h
//  NoticeXi
//
//  Created by li lei on 2020/5/26.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeZjDialogModel : NSObject
@property (nonatomic, strong) NSString *dialog_id;
@property (nonatomic, strong) NSString *resource_type;
@property (nonatomic, strong) NSString *resource_url;
@property (nonatomic, strong) NSString *resource_len;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *dialog_at;
@property (nonatomic, strong) NSString *collictionId;
@property (nonatomic, strong) NSString *source_type;
@end

NS_ASSUME_NONNULL_END
