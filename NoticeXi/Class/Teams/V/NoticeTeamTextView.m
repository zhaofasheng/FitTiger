//
//  NoticeTeamTextView.m
//  NoticeXi
//
//  Created by li lei on 2023/6/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamTextView.h"

@implementation NoticeTeamTextView

- (instancetype)initWithFrame:(CGRect)frame

{

    self = [super initWithFrame:frame];

    if (self) {

        //设置菜单
        
        UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:@"换行" action:@selector(selfMenu:)];
        NSArray *itmes = @[menuItem];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        
        [menuController setMenuItems:itmes];
        
        [menuController setMenuVisible:NO];
        
    }

    return self;

}

 

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{

    if (action == @selector(selfMenu:) && self.text.length) {

        return YES;

    }
    else if(action == @selector(paste:) ||
    action ==@selector(selectAll:)||
    action ==@selector(cut:)||
    action ==@selector(select:)
    ){
    BOOL isAppear = [super canPerformAction:action withSender:sender];
    return isAppear;
    }
    return NO;
}

-(void)selfMenu:(id)sender{
    self.oldRange = NSMakeRange(self.selectedRange.location+1, 0);
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSMutableAttributedString *hh = [[NSMutableAttributedString alloc] initWithAttributedString:[DDHAttributedMode setString:@"\n" setSize:15 setLengthString:@"\n" beginSize:0]];
    [mutableAttributedString insertAttributedString:hh atIndex:self.selectedRange.location];
    self.needBackOldPoint = YES;
    self.attributedText = mutableAttributedString;
    
}

@end
