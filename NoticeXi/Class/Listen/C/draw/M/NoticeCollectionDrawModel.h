//
//  NoticeCollectionDrawModel.h
//  NoticeXi
//
//  Created by li lei on 2020/6/16.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeDrawList.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeCollectionDrawModel : NSObject
@property (nonatomic, strong) NSString *collectionId;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSDictionary *artwork;
@property (nonatomic, strong) NoticeDrawList *drawModel;
@end

NS_ASSUME_NONNULL_END
