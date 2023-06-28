//
//  NoticeZjView.h
//  NoticeXi
//
//  Created by li lei on 2019/8/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeZjCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeZjView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *merchantCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, assign) BOOL isLimit;
@property (nonatomic, assign) BOOL isText;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSMutableArray *dataArr;//专辑数据
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *typeString;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) UILabel *noDataL;
@property (nonatomic, strong) NSString *allNumber;
- (instancetype)initWithFrame:(CGRect)frame isOther:(BOOL)isOther;
- (instancetype)initWithFrame:(CGRect)frame isText:(BOOL)isText isOther:(BOOL)isOther;
- (instancetype)initWithFrame:(CGRect)frame isLimit:(BOOL)isLimit;
@end

NS_ASSUME_NONNULL_END
