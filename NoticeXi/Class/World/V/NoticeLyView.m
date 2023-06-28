//
//  NoticeLyView.m
//  NoticeXi
//
//  Created by li lei on 2021/12/8.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeLyView.h"
#import "NoticeReadLyCell.h"
@implementation NoticeLyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 150, 25)];
        titleL.text = [NoticeTools getLocalStrWith:@"ly.myly"];
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.font = XGEightBoldFontSize;
        [self addSubview:titleL];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, DR_SCREEN_WIDTH, self.frame.size.height-50-20)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeReadLyCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.backgroundColor = self.backgroundColor;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self addSubview:self.tableView];
        
    
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
        [closeBtn setImage:UIImageNamed(@"Image_giveluyin") forState:UIControlStateNormal];
        [self addSubview:closeBtn];
        closeBtn.hidden = YES;
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        self.closeBtn = closeBtn;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upTap)];
        [self addGestureRecognizer:tap];
    
        UISwipeGestureRecognizer *uprecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [uprecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [self addGestureRecognizer:uprecognizer];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self addGestureRecognizer:recognizer];

    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.isUp) {
        [self upTap];
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
   if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
       [self closeClick];
   }
   if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
       [self upTap];
   }

}

- (void)closeClick{
    self.isUp = NO;
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-150-NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT/3*2);
    }
                     completion:^(BOOL finished) {
        self.closeBtn.hidden = YES;
    }];
}

- (void)upTap{
    if (!self.isUp) {
        self.isUp = YES;
        [UIView animateWithDuration:0.15f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                
                self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-DR_SCREEN_HEIGHT/3*2+20,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT/3*2);
        }
                         completion:^(BOOL finished) {
            self.closeBtn.hidden = NO;
            
        }];
        
    }
}


- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeReadLyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.liuyan = self.dataArr[indexPath.row]; 
    cell.line.hidden = NO;
    cell.cirView.hidden = YES;
    cell.contentView.backgroundColor = self.backgroundColor;
    cell.backView.backgroundColor = self.backgroundColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeLy *lyM = self.dataArr[indexPath.row];
    if (lyM.height1 < 40) {
        return 56 + (lyM.replyted_at.integerValue?(lyM.height2+10):0);
    }
    return lyM.height1+16+15 + (lyM.replyted_at.integerValue?(lyM.height2+10):0);
}

@end
