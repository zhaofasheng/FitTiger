//
//  NoticeBBSDetailSectionView.m
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSDetailSectionView.h"
#import "SPMultipleSwitch.h"
@implementation NoticeBBSDetailSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        
        UILabel *lyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0, 100, 40)];
        lyLabel.text = [NoticeTools getLocalStrWith:@"cao.liiuyan"];
        lyLabel.font = FIFTHTEENTEXTFONTSIZE;
        lyLabel.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:lyLabel];
        
        SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[@"热门",@"正序",@"倒序"]];
        switch1.titleFont = TWOTEXTFONTSIZE;
        switch1.frame = CGRectMake(DR_SCREEN_WIDTH-15-138,5,138,30);
        [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
        switch1.selectedTitleColor = GetColorWithName(VMainThumeWhiteColor);
        switch1.titleColor = GetColorWithName(VDarkTextColor);
        switch1.trackerColor = GetColorWithName(VMainThumeColor);
        
        switch1.backgroundColor = [NoticeTools getWhiteColor:@"#F7F7F7" NightColor:@"#11111F"];
        [self.contentView addSubview:switch1];
    }
    return self;
}

- (void)changeVale:(SPMultipleSwitch *)swithbtn{
    if (self.showTypeBlock) {
        self.showTypeBlock(swithbtn.selectedSegmentIndex);
    }
}

@end
