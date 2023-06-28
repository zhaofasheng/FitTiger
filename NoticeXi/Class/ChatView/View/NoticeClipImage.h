//
//  NoticeClipImage.h
//  NoticeXi
//
//  Created by li lei on 2020/7/17.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeClipImage : UIView
+ (UIImage *)clipImageWithText:(NSString *)text fromName:(NSString *)fromName toName:(NSString *)toName;
@end

NS_ASSUME_NONNULL_END
