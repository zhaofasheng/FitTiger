//
//  SCImageView.h
//  NoticeXi
//
//  Created by li lei on 2018/12/13.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCImageView : UIImageView

-(void) startRotating;
-(void) stopRotating;
-(void) resumeRotate;
-(void) startRotating1;
-(void) stopRotating1;
-(void) resumeRotate1;
-(void)startRotatingWithTime:(CGFloat)time;
@end

NS_ASSUME_NONNULL_END
