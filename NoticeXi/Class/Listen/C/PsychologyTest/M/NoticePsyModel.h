//
//  NoticePsyModel.h
//  NoticeXi
//
//  Created by li lei on 2019/1/21.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticePsyModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, strong) NSArray *result;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, assign) NSInteger choiceTag;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *choiceName;
@property (nonatomic, assign) BOOL sameAnswer;
@end

NS_ASSUME_NONNULL_END
