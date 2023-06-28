//
//  YYPhotoGroupView.h
//
//  Created by ibireme on 14/3/9.
//  Copyright (C) 2014 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NoticePhotoToolsView.h"
#import "NoticePhotoNavView.h"
/// Single picture's info.
@interface YYPhotoGroupItem : NSObject
@property (nonatomic, strong) UIView *thumbView; ///< thumb image, used for animation position calculation
@property (nonatomic, assign) CGSize largeImageSize;
@property (nonatomic, strong) NSURL *largeImageURL;
@property (nonatomic, strong) NSString *smallUrlString;
@end


@protocol NoticePhotoLookDelegate <NSObject>

@optional
- (void)scrollWithModel:(NoticeSmallArrModel *)model saveImage:(UIImage *)saveImage;
- (void)tapHideOrShow:(BOOL)hide;
@end

@interface YYPhotoGroupView : UIView
@property (nonatomic, readonly) NSArray *groupItems; ///< Array<YYPhotoGroupItem>
@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL blurEffectBackground; ///< Default is YES
@property (nonatomic, assign) BOOL isNeedTools;
@property (nonatomic, assign) BOOL ischangeIcon;
@property (nonatomic, assign) BOOL isSendToFriend;
@property (nonatomic, assign) BOOL isNeedChangeSaveImage;
@property (nonatomic, weak) id<NoticePhotoLookDelegate>delegate;
@property (nonatomic,copy) void (^sendToFriendBlock)(BOOL send,UIImage *sendImage);
@property (nonatomic,copy) void (^hideKeybord)(BOOL hideKeyBord);
@property (nonatomic,copy) void (^changeIcon)(BOOL changeIcon);
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithGroupItems:(NSArray *)groupItems;

- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;


- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismiss;
@end
