//
//  RXPopMenu.m
//  RXPopMenuDemo
//
//  Created by 赵发生 on 2018/3/7.
//  Copyright © 2018年 赵发生. All rights reserved.
//

#import "RXPopMenu.h"
#import "RXPopMenuArrow.h"
#import "RXPopBoxCell.h"


static NSString * const RXPopBoxCellID = @"RXPopBoxCell";
static CGFloat const RXPopBoxItemWidth = 60.f;

#define RXSafeTopHeight (RXScreenHeight/RXScreenWidth > 2 ? 44.f : 24.f)
#define RXScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define RXScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define RXHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RXArrowSize CGSizeMake(14.0, 7)

@interface RXPopMenu () <
UICollectionViewDataSource
>

@property (nonatomic, assign) RXPopMenuType menuType;

@property (nonatomic, strong) UICollectionView * popCollectionView;
@property (nonatomic, strong) RXPopMenuArrow * popArrow;
@property (nonatomic, strong) UIView * popView;
@property (nonatomic, strong) id targetView;
@property (nonatomic, assign) BOOL inNaviBar;

@property (nonatomic, assign) CGFloat visibleHeight;
@property (nonatomic, assign) CGRect targetViewFrame;

/** 元素集合 */
@property (nonatomic, strong) NSArray <RXPopMenuItem *> * items;

@end

@implementation RXPopMenu
@synthesize menuSize = _menuSize;
@synthesize itemHeight = _itemHeight;


#pragma mark - View Life Cycle -

+ (id)menuWithType:(RXPopMenuType)type {
    RXPopMenu * menu = [[RXPopMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
    menu.backgroundColor = [UIColor clearColor];
    menu.menuType = type;
    return menu;
}

+ (void)hideBy:(id)target {
    UIViewController * targetVC;
    UIView * containerView;
    if ([target isKindOfClass:[UIView class]]) {
        targetVC = [RXPopMenu VCForShowView:target];
    } else {
        targetVC = target;
    }
    if (targetVC.navigationController) {
        containerView = targetVC.navigationController.view;
    } else {
        containerView = targetVC.view;
    }
    [containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:self]) {
            RXPopMenu * menu = (RXPopMenu *)obj;
            [menu hideMenu];
            obj = nil;
            *stop = YES;
        }
    }];
}

- (void)hideMenu {
    [self removeFromSuperview];
    if (self.menuHideDone) {
        self.menuHideDone();
    }
}

- (void)showBy:(id)target withItems:(NSArray <RXPopMenuItem *>*)items keyboardHeight:(CGFloat)keyboardHeight {
    self.visibleHeight = RXScreenHeight - keyboardHeight;
    self.targetView = target;
    if (![target isKindOfClass:[UIView class]] &&
        ![target isKindOfClass:[UIBarButtonItem class]]) {
        return;
    }
    if ([NSStringFromClass([[self.targetView superview] class]) isEqualToString:@"_UITAMICAdaptorView"]) {
        self.inNaviBar = YES; // 在navigationBar上面
    }
    self.items = items;
    UIViewController * targetVC = [RXPopMenu VCForShowView:self.targetView];
    if (targetVC.navigationController) {
        [targetVC.navigationController.view addSubview:self];
    } else {
        [targetVC.view addSubview:self];
    }
    UIImpactFeedbackStyle style;
    if (@available(iOS 13.0, *)) {
        style = UIImpactFeedbackStyleSoft;
    } else {
        style = UIImpactFeedbackStyleMedium;
    }
    UIImpactFeedbackGenerator * generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
    [generator impactOccurred];
}

- (void)showBy:(id)target withItems:(NSArray <RXPopMenuItem *>*)items {
    [self showBy:target withItems:items keyboardHeight:0];
}

- (void)setItems:(NSArray<RXPopMenuItem *> *)items {
    if (_items != items) {
        _items = items;
        [self popView];
        if (!_hideArrow) [self popArrow];
    }
}

- (CGSize)menuSize {
    if (CGSizeEqualToSize(CGSizeZero, _menuSize)) {
        NSInteger line = _items.count/5 + (_items.count%5>0);
        CGFloat width = MIN(_items.count, 5)*RXPopBoxItemWidth + 20;
        CGFloat height = line*self.itemHeight + (line-1)*10;
        _menuSize = CGSizeMake(width, height);
    }
    return _menuSize;
}

- (void)setMenuSize:(CGSize)menuSize {
    if (!CGSizeEqualToSize(_menuSize, menuSize)) {
        _menuSize = menuSize;
        self.popCollectionView.frame = CGRectMake(0, 0, _menuSize.width, _menuSize.height);
    }
}

- (CGFloat)itemHeight {
    CGFloat height = self.menuType == RXPopMenuList ? 50.f : 54.f;
    return _itemHeight <= 0 ? height : _itemHeight;
}

- (void)setItemHeight:(CGFloat)itemHeight {
    if (_itemHeight != itemHeight) {
        _itemHeight = itemHeight;
        [_popCollectionView reloadData];
    }
}

#pragma mark - Lazy Load


- (UICollectionView *)popCollectionView {
    if (!_popCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(RXPopBoxItemWidth, self.itemHeight);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        _popCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.menuSize.width, self.menuSize.height) collectionViewLayout:layout];
        _popCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _popCollectionView.delegate = (id)self;
        _popCollectionView.dataSource = self;
        _popCollectionView.bounces = NO;
        _popCollectionView.backgroundColor = [UIColor blackColor];
        _popCollectionView.layer.cornerRadius = 8;
        _popCollectionView.layer.masksToBounds = YES;
        if (@available(iOS 11, *)) {
            _popCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_popCollectionView registerClass:[RXPopBoxCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    return _popCollectionView;
}

- (UIView *)popView {
    if (!_popView) {
        CGRect frame = [self getPopFrame];
        UIView * view = [[UIView alloc] initWithFrame:frame];
        view.layer.cornerRadius = 8;
        view.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.12].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 4);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 10;
        _popView = view;
        
        [_popView addSubview:self.popCollectionView];
        [self addSubview:_popView];
    }
    return _popView;
}

- (RXPopMenuArrow *)popArrow {
    if (!_popArrow) {
        CGRect frame = [self getArrowFrame];
        _popArrow = [[RXPopMenuArrow alloc] initWithFrame:frame Color:[UIColor blackColor]];
        [self addSubview:_popArrow];
        if (frame.origin.y <= self.targetViewFrame.origin.y) {
            _popArrow.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
        }
    }
    return _popArrow;
}

#pragma mark - Calculate Frame

- (CGRect)targetViewFrame {
    CGRect targetFrame;
    if (CGRectEqualToRect(_targetViewFrame, CGRectZero)) {
        CGRect targetRect = [self.targetView bounds];
        if (self.inNaviBar) {
            targetFrame = [self.targetView convertRect:targetRect toView:[RXPopMenu VCForShowView:self.targetView].navigationController.view];;
        } else {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            targetFrame = [self.targetView convertRect:targetRect toView:window];
            
            if (targetFrame.origin.y < 0) {
                targetFrame.size.height = MIN(self.visibleHeight, targetFrame.size.height + targetFrame.origin.y);
                targetFrame.origin.y = 0;
            } else {
                targetFrame.size.height = MIN(self.visibleHeight - targetFrame.origin.y, targetFrame.size.height);
            }
            CGFloat menuHei = self.menuSize.height + RXSafeTopHeight;
            if (targetFrame.origin.y < menuHei) {
                if (self.visibleHeight - targetFrame.origin.y - targetFrame.size.height < menuHei) {
                    targetFrame.origin.y = (targetFrame.origin.y + targetFrame.size.height)/2.0;
                }
            } else {
                targetFrame.size.height = self.visibleHeight - targetFrame.origin.y;
            }
        }
        targetFrame.origin.y = ceil(targetFrame.origin.y);
        _targetViewFrame = targetFrame;
    }
    return _targetViewFrame;
}

- (CGPoint)targetViewCenter {
    CGRect targetFrame = self.targetViewFrame;
    CGFloat centerX = targetFrame.origin.x + targetFrame.size.width/2.0;
    CGFloat centerY = targetFrame.origin.y + targetFrame.size.height/2.0;
    return CGPointMake(centerX, centerY);
}

- (CGRect)getPopFrame {
    CGRect targetFrame = self.targetViewFrame;
    CGPoint targetCenter = self.targetViewCenter;
    
    CGFloat menuWidth = self.menuSize.width;
    CGFloat menuHeight = self.menuSize.height;
    CGFloat spac = 10.f;
    
    CGRect popFrame = CGRectMake(targetCenter.x-menuWidth/2.0, 0, menuWidth, menuHeight);
    BOOL left = targetCenter.x / RXScreenWidth < 0.5;
    BOOL top = CGRectGetMinY(targetFrame) < menuHeight + RXSafeTopHeight;
    
    if (left) { // 左右边距控制
        popFrame.origin.x = MAX(popFrame.origin.x, spac);
    } else {
        popFrame.origin.x = MIN(popFrame.origin.x, RXScreenWidth-spac-menuWidth);
    }
    if (top) {  // 上下间距控制
        popFrame.origin.y = MAX(CGRectGetMaxY(targetFrame), spac) + RXArrowSize.height;
    } else {
        popFrame.origin.y = MIN(CGRectGetMinY(targetFrame) - menuHeight, self.visibleHeight-spac) - RXArrowSize.height;
    }
    popFrame.origin.y = ceil(popFrame.origin.y);
    return popFrame;
}

- (CGRect)getArrowFrame {
    CGRect targetFrame = self.targetViewFrame;
    
    CGFloat menuHeight = self.menuSize.height;
    BOOL top = CGRectGetMinY(targetFrame) < menuHeight + RXSafeTopHeight;
    
    CGRect arrowFrame = CGRectMake(0, 0, RXArrowSize.width, RXArrowSize.height);
    arrowFrame.origin.x = targetFrame.origin.x + targetFrame.size.width/2.0 - arrowFrame.size.width/2.0;
    
    if (top) {
        arrowFrame.origin.y = targetFrame.origin.y + targetFrame.size.height;
    } else {
        arrowFrame.origin.y = targetFrame.origin.y - RXArrowSize.height;
    }
    arrowFrame.origin.y = ceil(arrowFrame.origin.y);
    return arrowFrame;
}

- (void)setTargetView:(id)targetView {
    if (_targetView != targetView) {
        if ([targetView isKindOfClass:[UIView class]]) {
            _targetView = targetView;
        } else if ([targetView isKindOfClass:[UIBarButtonItem class]]) {
            if ([targetView customView]) {
                _targetView = [targetView customView];
            } else {
                NSAssert(1, @"Unsupport Type:Is not a View");
            }
        }
    }
}

+ (UIViewController *)VCForShowView:(id)view {
    if ([view isKindOfClass:[UIView class]]) {
        for (UIView * next = [view superview]; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                return (UIViewController *)nextResponder;
            }
        }
    } else if ([view isKindOfClass:[UIBarButtonItem class]]) {
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        if (window.windowLevel != UIWindowLevelNormal) {
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow * tmpWin in windows) {
                if (tmpWin.windowLevel == UIWindowLevelNormal) {
                    window = tmpWin;
                    break;
                }
            }
        }
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return nextResponder;
        else
            return window.rootViewController;
    }
    return nil;
}


#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RXPopMenuItem * item = self.items[indexPath.row];
    item.index = indexPath.row;
    RXPopBoxCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.bottomLabel.text = item.title;
    cell.line.hidden = (indexPath.row == (self.items.count-1))?YES:NO;
    cell.clipsToBounds = NO;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemActions) {
        self.itemActions(self.items[indexPath.row]);
        [self hideMenu];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideMenu];
}

@end


@implementation RXPopMenuItem


+ (id)itemTitle:(NSString *)title {
    RXPopMenuItem * item = [[RXPopMenuItem alloc] init];
    item.title = title;
    item.image = nil;
    return item;
}


@end
