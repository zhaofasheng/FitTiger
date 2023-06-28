//
//  NoticeChatSaveModel.h
//  NoticeXi
//
//  Created by li lei on 2021/12/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChatSaveModel : NSObject

@property (nonatomic, strong) NSString *pathName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *voiceFilePath;
@property (nonatomic, strong) NSString *imgUpPath;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *saveId;
@property (nonatomic, strong) NSString *voiceTimeLen;
@property (nonatomic, strong) NSString *isGif;
@end

NS_ASSUME_NONNULL_END
