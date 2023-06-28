//
//  NoticeListenCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/7.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeListenCell.h"

@implementation NoticeListenCell
{
    UIView *_mbView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        _iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(20,0, DR_SCREEN_WIDTH-40, 190)];
        _iamgeView.layer.cornerRadius = 14;
        _iamgeView.layer.masksToBounds = YES;
        _iamgeView.contentMode = UIViewContentModeScaleAspectFill;
        _iamgeView.backgroundColor =GetColorWithName(VBackColor);
        [self.contentView addSubview:_iamgeView];
        
        self.markView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
        [self.iamgeView addSubview:self.markView];
        self.markView.image = UIImageNamed(@"Image_artcile");
        self.markView.hidden = YES;
        
    }
    return self;
}

- (void)setLeadM:(NoticeLeaderModel *)leadM{
    _leadM = leadM;
    _iamgeView.frame = CGRectMake(20,0, DR_SCREEN_WIDTH-40,130);
    [_iamgeView sd_setImageWithURL:[NSURL URLWithString:leadM.cover_url]];
    self.markView.image = UIImageNamed(@"Image_leadcomple");
    self.markView.hidden = leadM.is_complete.intValue?YES:NO;
}

- (void)setWeb:(NoticeWeb *)web{
    _web = web;
    _iamgeView.frame = CGRectMake(20,0, DR_SCREEN_WIDTH-40,web.newbanner_url.length>10?190: 130);
    NSArray *array = [(web.newbanner_url.length>10?web.newbanner_url: web.banner_url) componentsSeparatedByString:@"?"];
    [_iamgeView sd_setImageWithURL:[NSURL URLWithString:array[0]]
              placeholderImage:GETUIImageNamed(@"img_empty")
                       options:SDWebImageRefreshCached];
    self.markView.hidden = web.is_new.intValue?NO:YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
