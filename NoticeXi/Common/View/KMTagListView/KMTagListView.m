//
//  KMTagListView.m
//  KMTag
//
//  Created by chavez on 2017/7/13.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "KMTagListView.h"
#import "KMTag.h"
#import "KMImgTag.h"
#import "NoticeComLabelModel.h"
@interface KMTagListView ()

@property (nonatomic,strong)NSMutableArray *tags;


@end

@implementation KMTagListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.pagingEnabled = YES;
    }
    return self;
}

- (NSMutableArray *)tags {
    if (_tags == nil) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (void)setupCustomeSubViewsWithTitles:(NSArray *)titles{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tags removeAllObjects];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        KMTag *tag = [[KMTag alloc] initWithFrame:CGRectZero];
        [tag setupCousTumeWithText:titles[i]];
        [self addSubview:tag];
        [self.tags addObject:tag];
        // 添加手势
        tag.tag = i;
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTagClick:)];
        [tag addGestureRecognizer:pan];
        tag.userInteractionEnabled = YES;
    }
    
    [self setupAllSubViews];
}

- (void)setupSubViewsWithTitles:(NSArray *)titles {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tags removeAllObjects];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        KMTag *tag = [[KMTag alloc] initWithFrame:CGRectZero];
        [tag setupWithText:titles[i]];
        [self addSubview:tag];
        [self.tags addObject:tag];
        // 添加手势
        tag.tag = i;
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTagClick:)];
        [tag addGestureRecognizer:pan];
        tag.userInteractionEnabled = YES;
    }
    
    [self setupAllSubViews];
}

- (void)setupCustomeImgSubViewsWithTitles:(NSMutableArray *)titles{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tags removeAllObjects];
    self.hasImge = YES;
    self.labelItems = titles;
    for (NSInteger i = 0; i < self.labelItems.count; i++) {
        KMImgTag *tag = [[KMImgTag alloc] initWithFrame:CGRectZero];
        tag.userInteractionEnabled = YES;
        NoticeComLabelModel *model = self.labelItems[i];
        [tag setImg:model.image_url name:model.title];
        [self addSubview:tag];
        [self.tags addObject:tag];
        // 添加手势
        tag.tag = i;
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTagClick:)];
        [tag addGestureRecognizer:pan];
        tag.userInteractionEnabled = YES;
    }
    
    [self setupAllSubViews];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self setupAllSubViews];
}


- (void)selectTagClick:(UIPanGestureRecognizer *)pan {
    if(self.hasImge){
        KMImgTag *tag = (KMImgTag *)pan.view;
        if(tag.tag > self.labelItems.count-1){//防止数组越界
            return;
        }
        NoticeComLabelModel *model = self.labelItems[tag.tag];
        model.isChoice = !model.isChoice;
        if(model.isChoice){
            tag.nameL.textColor = [UIColor colorWithHexString:@"#C2680E"];
            tag.backgroundColor = [[UIColor colorWithHexString:@"#C2680E"] colorWithAlphaComponent:0.05];
        }else{
            tag.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
            tag.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        }
        if ([self.delegate_ respondsToSelector:@selector(ptl_TagListView:didSelectTagViewAtIndex:selectContent:)]) {
            [self.delegate_ ptl_TagListView:self didSelectTagViewAtIndex:tag.tag selectContent:@""];
        }
        return;
    }
    KMTag *tag = (KMTag *)pan.view;
    if ([self.delegate_ respondsToSelector:@selector(ptl_TagListView:didSelectTagViewAtIndex:selectContent:)]) {
        [self.delegate_ ptl_TagListView:self didSelectTagViewAtIndex:tag.tag selectContent:tag.text];
    }
}



- (void)setupAllSubViews {
    
    if(self.hasImge){
        CGFloat marginX = 10;
        CGFloat marginY = 5;
        
        __block CGFloat x = 0;
        __block CGFloat y = 10;

        [self.tags enumerateObjectsUsingBlock:^(KMImgTag *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            
            CGFloat height = CGRectGetHeight(obj.frame);

            if (idx == 0) {
                x = marginX;
            }else {
                KMImgTag *tagl = self.tags[idx-1];
                x = CGRectGetMaxX(tagl.frame) + marginX;
                if ( x + CGRectGetWidth(obj.frame) + marginX > CGRectGetWidth(self.frame) ) {
                    x = marginX;
                    y += height;
                    y += marginY;
                }
            }
            CGRect frame = obj.frame;
            frame.origin = CGPointMake(x, y);
            obj.frame = frame;
            
        }];
        
        // 如果只有一行，居中显示
        if (y == 10) {
            
            [self.tags enumerateObjectsUsingBlock:^(KMImgTag *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CGFloat height = CGRectGetHeight(obj.frame);
                y = CGRectGetHeight(self.frame) / 2 - height / 2.0;
                
                if (idx == 0) {
                    x = marginX;
                }else {
                    
                    KMImgTag *tagl = self.tags[idx-1];
                    x = CGRectGetMaxX(tagl.frame) + marginX;
                }
                CGRect frame = obj.frame;
                frame.origin = CGPointMake(x, y);
                obj.frame = frame;
                
            }];
            
        }
        KMImgTag *tagl = self.tags.lastObject;
        x = CGRectGetMaxX(tagl.frame) + marginX;
        CGFloat contentHeight = CGRectGetMaxY(tagl.frame) + 10;
        if (contentHeight < CGRectGetHeight(self.frame)) {
            contentHeight = 0;
        }
        
        self.contentSize = CGSizeMake(0, contentHeight);
        return;
    }
    CGFloat marginX = 20;
    CGFloat marginY = 5;
    
    __block CGFloat x = 0;
    __block CGFloat y = 10;

    [self.tags enumerateObjectsUsingBlock:^(KMTag *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        
        CGFloat height = CGRectGetHeight(obj.frame);

        if (idx == 0) {
            x = marginX;
        }else {
            KMTag *tagl = self.tags[idx-1];
            x = CGRectGetMaxX(tagl.frame) + marginX;
            if ( x + CGRectGetWidth(obj.frame) + marginX > CGRectGetWidth(self.frame) ) {
                x = marginX;
                y += height;
                y += marginY;
            }
        }
        CGRect frame = obj.frame;
        frame.origin = CGPointMake(x, y);
        obj.frame = frame;
        
    }];
    
    // 如果只有一行，居中显示
    if (y == 10) {
        
        [self.tags enumerateObjectsUsingBlock:^(KMTag *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat height = CGRectGetHeight(obj.frame);
            y = CGRectGetHeight(self.frame) / 2 - height / 2.0;
            
            if (idx == 0) {
                x = marginX;
            }else {
                
                KMTag *tagl = self.tags[idx-1];
                x = CGRectGetMaxX(tagl.frame) + marginX;
            }
            CGRect frame = obj.frame;
            frame.origin = CGPointMake(x, y);
            obj.frame = frame;
            
        }];
        
    }
    KMTag *tagl = self.tags.lastObject;
    x = CGRectGetMaxX(tagl.frame) + marginX;
    CGFloat contentHeight = CGRectGetMaxY(tagl.frame) + 10;
    if (contentHeight < CGRectGetHeight(self.frame)) {
        contentHeight = 0;
    }
    
    self.contentSize = CGSizeMake(0, contentHeight);
}



@end
