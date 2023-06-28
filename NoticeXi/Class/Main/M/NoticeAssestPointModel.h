//
//  NoticeAssestPointModel.h
//  NoticeXi
//
//  Created by li lei on 2020/3/12.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeAssestPointModel : NSObject
@property (nonatomic, assign) BOOL hasMoveFloatView;
@property (nonatomic, assign) BOOL floatViewIsOut;
@property (nonatomic, assign) CGFloat outPointX;
@property (nonatomic, assign) CGFloat outPointY;
@property (nonatomic, assign) CGFloat inPointX;
@property (nonatomic, assign) CGFloat inPointY;
@property (nonatomic, assign) BOOL firstGetin;
@property (nonatomic, assign) BOOL hasSave;
@end

NS_ASSUME_NONNULL_END
