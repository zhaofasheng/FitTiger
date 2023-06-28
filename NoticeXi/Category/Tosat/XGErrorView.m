//
//  XGErrorView.m
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/5/3.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import "XGErrorView.h"

static const CGFloat TitleLabelFont = 14;

@interface XGErrorView()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation XGErrorView
- (id)initWithFrame:(CGRect)frame errorText:(NSString *)errorText {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		
		self.errorText = errorText;
		
	}
	return self;
}

- (void)setErrorText:(NSString *)errorText{
	_errorText = errorText;
	
	self.titleLabel.text = errorText;
}

- (UILabel *)titleLabel {
	if (_titleLabel == nil) {
		_titleLabel = [UILabel new];
		_titleLabel.font = [UIFont systemFontOfSize:TitleLabelFont];
		_titleLabel.numberOfLines = 2;
      
        _titleLabel.textColor = RGBColor(126, 134, 121);
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_titleLabel];
		[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self.mas_centerY).offset(- 60);
			make.left.equalTo(self).offset(14);
			make.right.equalTo(self).offset(- 14);
			make.height.mas_equalTo(50);
		}];
	}
	return _titleLabel;
}

@end
