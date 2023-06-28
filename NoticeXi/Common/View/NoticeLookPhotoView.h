//
//  NoticeLookPhotoView.h
//  NoticeXi
//
//  Created by li lei on 2020/12/28.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeLookPhotoView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *assestArr;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, copy) void (^choiceBlock)(UIImage *  __nullable  choiceImg,YYImage * __nullable yyImage,NSInteger index);
@property (nonatomic, copy) void (^textBlock)(NSAttributedString *attText,NSString *name,NSString *color);
- (void)needGetPhoto;

@property (nonatomic, strong) UIButton *lookImageBtn;
@property (nonatomic, strong) UIButton *goFirstBtn;
@end

NS_ASSUME_NONNULL_END
