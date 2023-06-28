//
//  CLAnimationView.m
//  弹出视图
//
//  Created by 李 红宝 on 16/1/16.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import "CLAnimationView.h"
#import "CLView.h"


#define  HH  147
#define SCREENWIDTH      [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT    [UIScreen mainScreen].bounds.size.height


@interface CLAnimationView ()<UIScrollViewDelegate>
{
    UIPageControl *pageShow ;
}
@property (nonatomic,strong) UIView *largeView;
@property (nonatomic) CGFloat count;
@property (nonatomic,strong) UIButton *chooseBtn;


@end



@implementation CLAnimationView



- (id)initWithTitleArray:(NSMutableArray *)titlearray picarray:(NSMutableArray *)picarray
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.largeView = [[UIView alloc]init];
        [_largeView  setFrame:CGRectMake(0, SCREENHEIGHT ,SCREENWIDTH,HH)];
        _largeView.backgroundColor = GetColorWithName(VBackColor);
        [self addSubview:_largeView];
        
        __weak typeof (self) selfBlock = self;
        
        _chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, HH - 44, SCREENWIDTH, 44)];
        [_chooseBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [_chooseBtn setBackgroundColor:GetColorWithName(VBackColor)];
        [_chooseBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        [_chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.largeView addSubview:_chooseBtn];
        
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,(HH-8-44-90)/2+5, SCREENWIDTH, 90)];
       // scroll.contentSize = CGSizeMake((titlearray.count +3)/4*SCREENWIDTH, 0);
        scroll.bounces = NO;
        scroll.pagingEnabled = YES;
        scroll.delegate = self;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        [_largeView addSubview:scroll];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scroll.frame), DR_SCREEN_WIDTH, 8)];
        line.backgroundColor = GetColorWithName(VBigLineColor);
        [_largeView addSubview:line];
        
        for (int i = 0; i < titlearray.count; i ++) {
            CLView *rr = [[CLView alloc]initWithFrame:CGRectMake(i *(SCREENWIDTH / picarray.count)+50, 40, SCREENWIDTH/picarray.count,90)];
            rr.tag = 10 + i;
            rr.sheetBtn.tag = i + 1;
            [rr.sheetBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",picarray[i]]] forState:UIControlStateNormal];
            [rr.sheetLab setText:[NSString stringWithFormat:@"%@",titlearray[i]]];
            
            [rr selectedIndex:^(NSInteger index, UILabel *sheetLab,id shareType) {
                [self dismiss];
                self.block(index,shareType);
                
            }];
            
            [scroll addSubview:rr];
        }
        
        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:selfBlock action:@selector(dismiss)];
        [selfBlock addGestureRecognizer:dismissTap];
    }
    return self;
}



- (void)selectedWithIndex:(CLBlock)block
{
    self.block = block;
}



- (void)moreshow{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self->_largeView.transform = CGAffineTransformMakeTranslation(0,  - HH);
        for (int i = 0; i < 6; i ++) {
            
            CGPoint CLCenterPoint = CGPointMake(SCREENWIDTH/5* i  + (SCREENWIDTH/10), 45);
            
            CLView *rr =  (CLView *)[self viewWithTag:10 + i];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    rr.center = CLCenterPoint;
                } completion:nil];
                
            });
        }
        
    } completion:^(BOOL finished) {
        
        NSLog(@"所有动画之行完毕");
    }];
}

- (void)CLBtnBlock:(CLBtnBlock)block
{
    self.btnBlock = block;
}


- (void)chooseBtnClick:(UIButton *)sender
{
    self.btnBlock(sender);
    [self dismiss];
}


-(void)show  
{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self->_largeView.transform = CGAffineTransformMakeTranslation(0,  - HH);
        for (int i = 0; i < 2; i ++) {
            CLView *rr =  (CLView *)[self viewWithTag:10 + i];
            CGPoint CLCenterPoint = CGPointMake(SCREENWIDTH/2-45-53/2+(45+53/2)*2*i, 45);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    rr.center = CLCenterPoint;
                } completion:nil];

            });
        }

    } completion:^(BOOL finished) {

        NSLog(@"所有动画之行完毕");
    }];
    
}

- (void)tap:(UITapGestureRecognizer *)tapG {
    [self dismiss];
}



- (void)dismiss {
    [UIView animateWithDuration:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self->_largeView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
