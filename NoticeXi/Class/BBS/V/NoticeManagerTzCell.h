//
//  NoticeManagerTzCell.h
//  NoticeXi
//
//  Created by li lei on 2020/11/18.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeBBSModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeManagerTzCell : BaseCell<UITextFieldDelegate>
@property (nonatomic, strong) NoticeBBSModel *bbsM;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) UITextField *numField;

@property (nonatomic,copy) void (^finishBlock)(NSString *newNum,NoticeBBSModel *bbsModel);
@end

NS_ASSUME_NONNULL_END
