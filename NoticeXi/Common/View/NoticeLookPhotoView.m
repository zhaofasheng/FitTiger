//
//  NoticeLookPhotoView.m
//  NoticeXi
//
//  Created by li lei on 2020/12/28.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeLookPhotoView.h"
#import "NoticeLookImageCell.h"
#import "NoticeGetPhotosFromLibary.h"
@implementation NoticeLookPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = GetColorWithName(VlineColor);
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(0,2,DR_SCREEN_WIDTH,(305+BOTTOM_HEIGHT));
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = GetColorWithName(VlineColor);
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeLookImageCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.movieTableView];
        
        self.lookImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-40, self.frame.size.height-BOTTOM_HEIGHT-20-40, 40, 40)];
        [self.lookImageBtn setBackgroundImage:UIImageNamed(@"Image_lookImageTo") forState:UIControlStateNormal];
        [self addSubview:self.lookImageBtn];
        [self.lookImageBtn addTarget:self action:@selector(gotoImage) forControlEvents:UIControlEventTouchUpInside];
        

//        self.goFirstBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-115, self.frame.size.height-BOTTOM_HEIGHT-20-40, 40, 40)];
//        [self.goFirstBtn setBackgroundImage:UIImageNamed(@"Image_gotofirst") forState:UIControlStateNormal];
//        [self addSubview:self.goFirstBtn];
//        [self.goFirstBtn addTarget:self action:@selector(gotoFirst) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)gotoFirst{
    [self.movieTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)gotoImage{
    [self.movieTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.assestArr.count>=18?18:17) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)needGetPhoto{

    [self getAllPhoto];
    
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus != PHAuthorizationStatusAuthorized) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = SIXTEENTEXTFONTSIZE;
        
        label.transform = CGAffineTransformMakeRotation(M_PI / 2);
        NSString *str = @"还没有开启相册权限呢\n\n";
        label.attributedText = [DDHAttributedMode setColorString:@"还没有开启相册权限呢\n\n点击开启" setColor:GetColorWithName(VMainThumeColor) setLengthString:@"点击开启" beginSize:str.length];
        self.movieTableView.tableFooterView = label;
        label.backgroundColor = GetColorWithName(VBackColor);
        label.numberOfLines = 0;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPhoto)];
        [label addGestureRecognizer:tap];
    }
}

- (void)gotoPhoto{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:url options:@{} completionHandler:nil];
            }
        } else {
            [application openURL:url options:@{} completionHandler:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < 15) {
        return DR_SCREEN_WIDTH-70+2;
    }else{
        UIImage *img = self.assestArr[indexPath.row];
        return img.size.width/img.size.height*(305+BOTTOM_HEIGHT)+2;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 15) {
        NoticeBackQustionModel *model = self.assestArr[indexPath.row];
        if (self.textBlock) {
            self.textBlock(model.contentAtt,model.name,model.color);
        }
    }else{
        if (self.choiceBlock) {
            if (indexPath.row < 18 && indexPath.row >= 15) {
                self.choiceBlock(nil,self.assestArr[indexPath.row],indexPath.row);
            }else{
               self.choiceBlock(self.assestArr[indexPath.row],nil,indexPath.row);
            }
        }
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assestArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeLookImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.index = indexPath.row;
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    if (indexPath.row < 15) {
        cell.looKImageView.frame = CGRectMake(0, 0,DR_SCREEN_WIDTH-70, (305+BOTTOM_HEIGHT));
        cell.questionM = self.assestArr[indexPath.row];
    }else{
        cell.looKImageView.image = self.assestArr[indexPath.row];
        UIImage *img = self.assestArr[indexPath.row];
        cell.looKImageView.frame = CGRectMake(0, 0,img.size.width/img.size.height*(305+BOTTOM_HEIGHT), (305+BOTTOM_HEIGHT));
    }

    if (indexPath.row >= 15 && indexPath.row < 18) {
        cell.name1L.hidden = NO;
        cell.name1L.frame = CGRectMake(cell.looKImageView.frame.size.width-10-61, 10, 61, 20);
    }else{
        cell.name1L.hidden = YES;
    }
    cell.line.frame = CGRectMake(cell.looKImageView.frame.size.width-2, 0, 2, cell.looKImageView.frame.size.height);
    
    __weak typeof(self) weakSelf = self;
    cell.gotImageBlock = ^(BOOL goImage) {
        [weakSelf.movieTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.assestArr.count>=18?18:17) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    };
    cell.goFirstBlock = ^(BOOL goFirst) {
        [weakSelf.movieTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    };
    return cell;
}


- (void)getAllPhoto{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        self.assestArr = [NoticeGetPhotosFromLibary getPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            //放在主线程中
            [self.movieTableView reloadData];
        });
    });
}
@end
