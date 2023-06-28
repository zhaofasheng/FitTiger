//
//  NoticeVoiceReadModel.h
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceReadModel : NSObject

@property (nonatomic, strong) NSString *readId;//阅读id
@property (nonatomic, strong) NSString *cover_url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *read_num;
@property (nonatomic, strong) NSString *show_at;
@property (nonatomic, strong) NSString *is_hot;
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSAttributedString *fourAttTextStr;
@end

NS_ASSUME_NONNULL_END
