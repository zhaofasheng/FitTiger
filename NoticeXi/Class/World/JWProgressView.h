//
//  JWProgressView.h
//  NoticeXi
//
//  Created by li lei on 2020/3/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWProgressView;

@protocol JWProgressViewDelegate <NSObject>

-(void)progressViewOver:(JWProgressView *)progressView;

@end

@interface JWProgressView : UIView

//进度值0-1.0之间
@property (nonatomic,assign)CGFloat progressValue;


//内部label文字
@property(nonatomic,strong)NSString *contentText;

//value等于1的时候的代理
@property(nonatomic,weak)id<JWProgressViewDelegate>delegate;

@property (nonatomic, strong) CAShapeLayer *backGroundLayer;      //背景图层
@property (nonatomic, strong) CAShapeLayer *frontFillLayer;       //用来填充的图层
@property (nonatomic, strong) UILabel *contentLabel;              //中间的label
@property (nonatomic, strong) UILabel *timeL;

@end
