//
//  NoticeTeamTextView.h
//  NoticeXi
//
//  Created by li lei on 2023/6/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTeamTextView : UITextView

/**
 占位符的文字位置
 */
@property(nonatomic,assign)CGPoint placePoint;
@property (nonatomic, assign) BOOL needBackOldPoint;//需要回到原始位置
@property(nonatomic) NSRange oldRange;
@end

NS_ASSUME_NONNULL_END
