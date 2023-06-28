//
//  NoticePhotoLookViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/6/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticePhotoLookViewController : UIViewController
@property (nonatomic, strong) UIImageView *imageCellView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *allDataArr;
@property (nonatomic, strong) NSMutableArray *lagerUrlArr;
@end

NS_ASSUME_NONNULL_END
