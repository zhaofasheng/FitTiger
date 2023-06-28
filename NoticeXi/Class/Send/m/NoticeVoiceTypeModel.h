//
//  NoticeVoiceTypeModel.h
//  NoticeXi
//
//  Created by li lei on 2022/3/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceTypeModel : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *typeImageName;

@property (nonatomic, assign) NSInteger needLeavel;
@property (nonatomic, assign) int cRate;//采样率 44100
@property (nonatomic, assign) int rate;//速率
@property (nonatomic, assign) int speed;//速度
@property (nonatomic, assign) int fenbei;//音调

@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, assign) BOOL isPalying;
@property (nonatomic, assign) BOOL isRePaly;

@property (nonatomic, strong) UIImage *currentImg;

@end

NS_ASSUME_NONNULL_END
