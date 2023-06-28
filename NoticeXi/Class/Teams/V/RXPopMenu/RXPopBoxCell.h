//
//  RXPopBoxCell.h
//  COMEngine
//
//  Created by 赵发生 on 2021/2/25.
//  Copyright © 2021 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RXPopBoxCell : UICollectionViewCell

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIColor * backColor;
@property (strong, nonatomic) UILabel *bottomLabel;
@end

NS_ASSUME_NONNULL_END
