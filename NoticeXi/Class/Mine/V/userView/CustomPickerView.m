//
//  CustomPickerView.m
//  eCamera
//
//  Created by wsg on 2017/4/18.
//  Copyright © 2017年 wsg. All rights reserved.
//

#import "CustomPickerView.h"

#define itemHeight 70
@interface CustomPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation CustomPickerView{
    UIPickerView *picker;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self performSelector:@selector(initPickerView)];
    }
    return self;
}
/**
 *  初始化 选择器
 */
-(void)initPickerView{
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/2);
    rotate = CGAffineTransformScale(rotate, 0.1, 1);
    //旋转 -π/2角度
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height*10, self.frame.size.width)];
    
    [picker setTag: 10086];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = false;
    [picker setBackgroundColor:[UIColor clearColor]];

    UIView *bgV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
    [bgV addSubview:picker];
    [self addSubview:bgV];
    [picker setTransform:rotate];
    picker.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
}

- (void)reloadData{
    [picker reloadAllComponents];
}

/**
 *  pickerView代理方法
 *
 *
 *  @return pickerView有多少个元素
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.isNomerData) {
        return self.dataModel.count*50;
    }
    return self.dataModel.count;
}
/**
 *  pickerView代理方法
 *
 *  @return pickerView 有多少列
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
/**
 *  pickerView代理方法
 *
 *  @return 每个 item 显示的 视图
 */
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    CGAffineTransform rotateItem = CGAffineTransformMakeRotation(M_PI/2);
    rotateItem = CGAffineTransformScale(rotateItem, 1, 10);
    
    UILabel *itemView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,60,25)];
    if (self.isNomerData) {
        itemView.text = [self.dataModel objectAtIndex:(row%[self.dataModel count])];
        itemView.textColor = [UIColor colorWithHexString:@"#737780"];
        itemView.font = XGTwentyBoldFontSize;
    }else{
        itemView.layer.cornerRadius = 25/2;
        itemView.layer.masksToBounds = YES;
        itemView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F90"];
        NSMutableDictionary *parm = self.dataModel[row];
        itemView.text = [parm objectForKey:@"mon"];
        itemView.textColor = [UIColor colorWithHexString:@"#737780"];
        itemView.font = XGTwentyBoldFontSize;
    }

    itemView.textAlignment = NSTextAlignmentCenter;
    itemView.transform = rotateItem;
    
    //在该代理方法里添加以下两行代码删掉上下的黑线
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    if (pickerView.subviews.count >= 3) {
        [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    }
    
    return itemView;
}


/**
 *  pickerVie代理方法
 *
 *
 *  @return 每个item的宽度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component __TVOS_PROHIBITED{
    if (self.isNomerData) {
        return 50;
    }
    return 56;
}
/**
 *  pickerView代理方法
 
 *
 *  @return 每个item的高度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    if (self.isNomerData) {
        return 50;
    }
    return itemHeight;
}


/**
 *  pickerView滑动到指定位置
 *
 *  @param scrollToIndex 指定位置
 */
-(void)scrollToIndex:(NSInteger)scrollToIndex{
    [picker selectRow:scrollToIndex inComponent:0 animated:true];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.isNomerData) {
        NSUInteger max = 0;
        
        NSUInteger base10 = 0;
        
        if(component == 0)
            
        {
            
            max = [self.dataModel count]*50;
            
            base10 = (max/2)-(max/2)%[self.dataModel count];
            
            [pickerView selectRow:[pickerView selectedRowInComponent:component]%[self.dataModel count]+base10 inComponent:component animated:false];
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectTitlt: tag:)]) {
                [self.delegate selectTitlt:[self.dataModel objectAtIndex:(row%[self.dataModel count])] tag:self.tag];
            }
        }
    }
    else{
       [self.delegate pickerView:pickerView didSelectRow:row];
    }
    
}

@end
