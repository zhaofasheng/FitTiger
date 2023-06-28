//
//  NoticeBingGanCollCell.m
//  NoticeXi
//
//  Created by li lei on 2021/4/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBingGanCollCell.h"

@implementation NoticeBingGanCollCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.localLmageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (DR_SCREEN_WIDTH-100)/7, (DR_SCREEN_WIDTH-100)/7)];
        self.localLmageView.contentMode = UIViewContentModeScaleAspectFill;
        self.localLmageView.clipsToBounds = YES;
        self.localLmageView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:self.localLmageView];
        self.localLmageView.layer.cornerRadius = self.localLmageView.frame.size.width/2;
        self.localLmageView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setPeopleM:(NoticeFriendAcdModel *)peopleM{
    _peopleM = peopleM;
    if (peopleM.localData) {
        self.localLmageView.image = UIImageNamed(@"Image_morebingg");
    }else{
        [self.localLmageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:peopleM.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    }
    
}
@end
