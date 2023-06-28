//
//  NoticePhotoCell.m
//  NoticeXi
//
//  Created by li lei on 2018/10/25.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticePhotoCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticePhotoLookViewController.h"
@implementation NoticePhotoCell
{
    UIView *_mbView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = GetColorWithName(VBackColor);
      
        self.imageCellView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageCellView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageCellView.clipsToBounds = YES;
        self.imageCellView.image = UIImageNamed(@"sharesdk");
        [self.contentView addSubview:self.imageCellView];
        
        _mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.imageCellView.frame.size.width, self.imageCellView.frame.size.height)];
        _mbView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        [self.imageCellView addSubview:_mbView];
        _mbView.hidden = [NoticeTools isWhiteTheme]?YES:NO;
        
        self.imageCellView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.imageCellView addGestureRecognizer:tap];
    }
    return self;
}

- (void)setIsUserSet:(BOOL)isUserSet{
    _isUserSet = isUserSet;
    if (_isUserSet) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.delegteButton.hidden = NO;
    }

}

- (void)setSmallModel:(NoticeSmallArrModel *)smallModel{
    _smallModel = smallModel;
    [self.imageCellView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:smallModel.imgUrl]] placeholderImage:GETUIImageNamed(@"img_empty")];
}

- (void)setCoverModel:(NoticeCoverModel *)coverModel{
    _coverModel = coverModel;
    [self.imageCellView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:coverModel.coverUrl]] placeholderImage:GETUIImageNamed(@"img_empty")];
}

- (void)tapAction{
    if (_isUserSet) {
    
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = self.imageCellView;
        item.largeImageURL = [NSURL URLWithString:_coverModel.coverUrl];
        YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
        UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        [view presentFromImageView:self.imageCellView
                       toContainer:toView
                          animated:YES completion:nil];
        return;
    }
    NSMutableArray *lagerUrlArr = [NSMutableArray new];
    for (NSString *str in self.lagerUrlArr) {
        [lagerUrlArr addObject:str];
    }
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.imageCellView;
    item.largeImageURL     = [NSURL URLWithString:_smallModel.imgUrl];
    if (self.lagerUrlArr.count) {
        [lagerUrlArr replaceObjectAtIndex:self.index withObject:item];
    }
    
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NoticePhotoLookViewController *ctl = [[NoticePhotoLookViewController alloc] init];
    ctl.lagerUrlArr = lagerUrlArr;
    ctl.allDataArr = self.allDataArr;
    ctl.imageCellView = self.imageCellView;
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    
}

- (UIButton *)delegteButton{
    if (!_delegteButton) {
        _delegteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.imageCellView.frame.size.width-25, 0, 25, 25)];
        [_delegteButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_xqbfm_b":@"Image_xqbfm_y") forState:UIControlStateNormal];
        [_delegteButton addTarget:self action:@selector(deleteImg) forControlEvents:UIControlEventTouchUpInside];
        [self.imageCellView addSubview:_delegteButton];
        _delegteButton.hidden = YES;
    }
    return _delegteButton;
}

- (void)deleteImg{
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegateImageAt:)]) {
        [self.delegate delegateImageAt:self.index];
    }
}
@end
