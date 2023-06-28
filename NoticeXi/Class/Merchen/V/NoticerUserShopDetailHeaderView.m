//
//  NoticerUserShopDetailHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2023/4/11.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticerUserShopDetailHeaderView.h"
#import "NoticeShopForLabelcomCell.h"
@implementation NoticerUserShopDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 80, 80)];
        self.iconImageView.layer.cornerRadius = 4;
        self.iconImageView.layer.masksToBounds = YES;
        [self addSubview:self.iconImageView];
        
        self.shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(105, 24, DR_SCREEN_WIDTH-107, 25)];
        self.shopNameL.font = XGEightBoldFontSize;
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.shopNameL];
        
        self.stausNumL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shopNameL.frame), 26, 54, 20)];
        self.stausNumL.font = ELEVENTEXTFONTSIZE;
        self.stausNumL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.stausNumL.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.stausNumL.layer.cornerRadius = 10;
        self.stausNumL.layer.masksToBounds = YES;
        self.stausNumL.textAlignment = NSTextAlignmentCenter;
        self.stausNumL.text = @"服务中";
        [self addSubview:self.stausNumL];
        
        self.orderNumL = [[UILabel alloc] initWithFrame:CGRectMake(105, 59, DR_SCREEN_WIDTH-107, 20)];
        self.orderNumL.font = FOURTHTEENTEXTFONTSIZE;
        self.orderNumL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self addSubview:self.orderNumL];
        
        self.playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-82, 54, 72, 28)];
        [self addSubview:self.playImageView];
        self.playImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [self.playImageView addGestureRecognizer:tapp];
        self.playImageView.image = UIImageNamed(@"playuservoiceimg");
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(23,0,72-23-5-3, 28)];
        self.timeL.font = [UIFont systemFontOfSize:9];
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.playImageView addSubview:self.timeL];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.iconImageView.frame)+15, DR_SCREEN_WIDTH-30, 83)];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:backView];
        [backView addSubview:self.defaultL];
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 104, 20)];
        numL.font = XGFourthBoldFontSize;
        numL.textColor = [UIColor colorWithHexString:@"#25262E"];
        numL.text = @"对店主的印象：";
        [backView addSubview:numL];
        
        self.isReplay = YES;
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(10,30,DR_SCREEN_WIDTH-40, 53);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeShopForLabelcomCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.hidden = YES;
        self.movieTableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [backView addSubview:self.movieTableView];
    }
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeShopForLabelcomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = _labelArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _labelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeComLabelModel *model = _labelArr[indexPath.row];
    return model.showStrWidth+54;
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopModel.role_img_url]];
    self.orderNumL.text = [NSString stringWithFormat:@"已服务%d单",shopModel.order_num.intValue];
    
    self.shopNameL.text = shopModel.shop_name;
    self.shopNameL.frame = CGRectMake(105, 24, GET_STRWIDTH(shopModel.shop_name, 19, 25), 25);
    self.stausNumL.frame = CGRectMake(CGRectGetMaxX(self.shopNameL.frame), 26, 54, 20);
    self.stausNumL.hidden = shopModel.operate_status.intValue==3?NO:YES;
    
    self.timeL.text = shopModel.introduce_len.intValue? [NSString stringWithFormat:@"%@s",shopModel.introduce_len] : @"空";
    

}

- (void)setLabelArr:(NSMutableArray *)labelArr{
    _labelArr = labelArr;
    if(_labelArr.count){
        self.defaultL.hidden = YES;
        self.movieTableView.hidden = NO;
        [self.movieTableView reloadData];
    }else{
        self.defaultL.hidden = NO;
        self.movieTableView.hidden = YES;
    }
}

- (UILabel *)defaultL{
    if (!_defaultL) {
        _defaultL = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, DR_SCREEN_WIDTH-30, 53)];
        _defaultL.textAlignment = NSTextAlignmentCenter;
        _defaultL.font = TWOTEXTFONTSIZE;
        _defaultL.text = @"欸 这里空空的";
        _defaultL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    }
    return _defaultL;
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

- (void)stopPlay{
    self.isReplay = YES;
    [self.audioPlayer stopPlaying];
}

- (void)playNoReplay{
    
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:self.shopModel.introduce_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;

    self.audioPlayer.playComplete = ^{
        weakSelf.timeL.text = [NSString stringWithFormat:@"%@s",weakSelf.shopModel.introduce_len];
        weakSelf.isReplay = YES;

    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] >weakSelf.shopModel.introduce_len.integerValue) {
            currentTime = weakSelf.shopModel.introduce_len.integerValue;
        }

        if ([[NSString stringWithFormat:@"%.f",weakSelf.shopModel.introduce_len.integerValue-currentTime] isEqualToString:@"0"] ||  ((weakSelf.shopModel.introduce_len.integerValue-currentTime)<1) || [[NSString stringWithFormat:@"%.f",weakSelf.shopModel.introduce_len.integerValue-currentTime] isEqualToString:@"-0"]) {
            weakSelf.isReplay = YES;
  
            if ((weakSelf.shopModel.introduce_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
            }
        }
        weakSelf.timeL.text = [[NSString stringWithFormat:@"%.fs",weakSelf.shopModel.introduce_len.integerValue-currentTime] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    };
}

@end
