//
//  KMImgTag.h
//  NoticeXi
//
//  Created by li lei on 2023/4/16.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KMImgTag : UIView
- (void)setImg:(NSString *)imgUrl name:(NSString *)name;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIImageView *imgView;
@end

NS_ASSUME_NONNULL_END
