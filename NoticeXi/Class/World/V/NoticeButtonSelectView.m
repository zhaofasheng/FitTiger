//
//  NoticeButtonSelectView.m
//  NoticeXi
//
//  Created by li lei on 2023/5/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeButtonSelectView.h"

@implementation NoticeButtonSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        self.bowenImageView = [[UIImageView alloc] init];
        self.bowenImageView.image = UIImageNamed(@"Image_bowenchoixe");
        [self addSubview:self.bowenImageView];
        
        NSArray *titleArr = @[[NoticeTools getLocalStrWith:@"yl.xinqing"],[NoticeTools chinese:@"小社团" english:@"Group" japan:@"グルップ"],[NoticeTools getLocalStrWith:@"help.qiuz"]];
        //
        self.nomerWidth1  = GET_STRWIDTH(titleArr[0], 16, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        self.nomerWidth2  = GET_STRWIDTH(titleArr[1], 16, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        self.nomerWidth3  = GET_STRWIDTH(titleArr[2], 16, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        
        self.boldWidth1  = GET_STRWIDTH(titleArr[0], 23, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)+3;
        self.boldWidth2  = GET_STRWIDTH(titleArr[1], 23, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)+3;
        self.boldWidth3  = GET_STRWIDTH(titleArr[2], 23, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)+3;
        for (int i = 0;i<3; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.userInteractionEnabled = YES;
            label.tag = i;
            label.textColor = [UIColor colorWithHexString:@"#25262E"];
            label.font = SIXTEENTEXTFONTSIZE;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = titleArr[i];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indxTap:)];
            [label addGestureRecognizer:tap];
            [self addSubview:label];
            
            if(i == 0){
                self.voiceBtn = label;
                self.voiceBtn.textAlignment = NSTextAlignmentLeft;
            }else if (i == 1){
                self.groupBtn = label;
            }else{
                self.helpBtn = label;
            }
        }
        self.voiceBtn.frame = CGRectMake(15, 0, self.boldWidth1,self.frame.size.height);
        self.groupBtn.frame = CGRectMake(CGRectGetMaxX(self.voiceBtn.frame)+20, 0, self.boldWidth2,self.frame.size.height);
        self.helpBtn.frame = CGRectMake(CGRectGetMaxX(self.groupBtn.frame)+20, 0, self.boldWidth3,self.frame.size.height);
        [self refreshButtonFrame:0];
    }
    return self;
}

- (void)refreshButtonFrame:(NSInteger)index{
    
    self.voiceBtn.font = index==0?[UIFont fontWithName:@"zihunxinquhei" size:21]:SIXTEENTEXTFONTSIZE;
    
    self.groupBtn.font = index==1?[UIFont fontWithName:@"zihunxinquhei" size:21]:SIXTEENTEXTFONTSIZE;
    
    self.helpBtn.font = index==2?[UIFont fontWithName:@"zihunxinquhei" size:21]:SIXTEENTEXTFONTSIZE;
    
    if(index == 0){
        self.bowenImageView.frame = CGRectMake(self.voiceBtn.frame.origin.x,self.frame.size.height/2+5, self.voiceBtn.frame.size.width, 11);
    }else if (index == 1){
        self.bowenImageView.frame = CGRectMake(self.groupBtn.frame.origin.x,self.frame.size.height/2+5, self.groupBtn.frame.size.width, 11);
    }else{
        self.bowenImageView.frame = CGRectMake(self.helpBtn.frame.origin.x,self.frame.size.height/2+5, self.helpBtn.frame.size.width, 11);
    }
}

- (void)setChoiceIndex:(NSInteger)choiceIndex{
    _choiceIndex = choiceIndex;
    [self refreshButtonFrame:choiceIndex];
}

- (void)indxTap:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    if(self.choiceSelectIndexBlock){
        self.choiceSelectIndexBlock(label.tag);
    }
    [self refreshButtonFrame:label.tag];
}

@end
