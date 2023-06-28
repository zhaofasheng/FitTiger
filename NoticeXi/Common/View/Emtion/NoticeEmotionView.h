//
//  NoticeEmotionView.h
//  NoticeXi
//
//  Created by li lei on 2020/10/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeEmtionCell.h"
#import "TZImagePickerController.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeEmotionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *choiceArr;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, assign) BOOL isBeginChoice;
@property (nonatomic, assign) BOOL isCu;//官方表情包
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, copy) void (^choiceBlock)(NSInteger num);
@property (nonatomic, copy) void (^refashBlock)(BOOL reafsh);
@property (nonatomic, copy) void (^collectBlock)(BOOL collect);
@property (nonatomic, copy) void (^noChoiceBlock)(BOOL reafsh);
@property (nonatomic, copy) void (^addMoreBlock)(BOOL addMore);
@property (nonatomic, copy) void (^sendBlock)(NSString *url, NSString *buckId,NSString *pictureId,BOOL isHot);
@property (nonatomic, strong) NSMutableArray *photoArr;
@property (nonatomic, strong) NSMutableArray *imgArr;
- (void)clearChoice;
- (void)moveClick;
- (void)deleteClick;
- (void)requestEmotion;
- (instancetype)initWithCu;
- (instancetype)initWithHot;
- (instancetype)initWithNoHot;
@end

NS_ASSUME_NONNULL_END
