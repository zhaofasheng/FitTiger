//
//  NoticePrivacySetViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticePrivacySetViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Sino.h"
@interface NoticePrivacySetViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationmanager;//定位服务
@property (nonatomic, strong) NSString *currentCity;//当前城市
@property (nonatomic, strong) NSString *strlatitude;//经度
@property (nonatomic, strong) NSString *strlongitude;//纬度
@end

@implementation NoticePrivacySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.headerTitle;
    
    if (self.tag == 3) {
        [self getLocation];
    }
    
    if (self.tag == 5) {
        self.navigationItem.title = [NoticeTools getTextWithSim:@"话题隐私设置" fantText:@"話題隱私設置"];
    }
    
    
    if (self.tag < 3 || self.tag == 5) {
         NSArray *arr = [NoticeTools isSimpleLau]?@[@"设置了「仅限学友」时非好友点击「悄悄话」将有如图提示",@"设置了「仅限学友」时非好友将不能向你发起私聊",@"允许还不是室友的用户收听最近的「记忆」「相册」「时光机」(不含私密心情)"]:@[@"設置了「僅限学友」時非学友點擊「回聲」將有如圖提示",@"設置了「僅限学友」時非学友將不能向妳發起私聊",@"允許還不是学友的用戶收聽最近的「記憶」「相冊」「時光機」(不含私密心情)"];
        NSArray *imgArr = @[@"sect_img1",@"sect_img2"];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-65*2-40-BOTTOM_HEIGHT)];
        self.tableView.tableFooterView = footView;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,self.tag == 5 ?0: 25, DR_SCREEN_WIDTH-30,self.tag == 5? 62: 12)];
 
        NSString *str = self.tag ==5 ?([NoticeTools isSimpleLau]?@"设置了「隐藏」时自己的同话题心情将被\n排除在搜索结果之外，自己和他人都看不到":@"設置了「隱藏」時自己的同話題心情將被\n排除在搜索結果之外，自己和他人都看不到") : arr[self.tag];
        if (self.tag == 2) {
            label.textAlignment = NSTextAlignmentLeft;
            self.navigationItem.title = @"最近心情";
            str = arr[2];
            label.frame = CGRectMake(15,0, DR_SCREEN_WIDTH-30,62);
        }else{
            label.textAlignment = NSTextAlignmentCenter;
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label.attributedText = attributedString;
        label.numberOfLines = 0;
        
        
        label.font = TWOTEXTFONTSIZE;
        label.textColor = GetColorWithName(VDarkTextColor);
        [footView addSubview:label];
        
        CGFloat imgHeight =self.tag==5 ? 305: 308;
        CGFloat imgWidth =self.tag==5 ? 215: 176;
        
        if (self.tag != 2) {//室友可见心情不需要图片
            UIImageView *showImgView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-imgWidth)/2, CGRectGetMaxY(label.frame)+20, imgWidth, imgHeight)];
            showImgView.image = UIImageNamed(self.tag == 5?@"sect_img5" : imgArr[self.tag]);
            [footView addSubview:showImgView];
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.tag == 5) {
        if (!self.boolStr.boolValue) {//已经是所有人
            if (indexPath.row == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self changeWihtvalue:@"1"];
            }
        }else{
            if (indexPath.row == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self changeWihtvalue:@"0"];
            }
        }
        return;
    }
    
    if (self.tag < 2) {
        if (!self.boolStr.boolValue) {//已经是所有人
            if (indexPath.row == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self changeWihtvalue:@"1"];
            }
        }else{
            if (indexPath.row == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                 [self changeWihtvalue:@"0"];
            }
        }
    }else{
        
        if (self.tag == 2) {
            if ([self.boolStr isEqualToString:@"0"] && indexPath.row == 0) {
                return;
            }
            if ([self.boolStr isEqualToString:@"7"] && indexPath.row == 1) {
                return;
            }
            if ([self.boolStr isEqualToString:@"30"] && indexPath.row == 2) {
                return;
            }
            if ([self.boolStr isEqualToString:@"-1"] && indexPath.row == 3) {
                return;
            }
            NSString *value = nil;
            if (indexPath.row == 0) {
                value = @"0";
            }else if (indexPath.row ==1){
                value = @"7";
            }else if (indexPath.row ==2){
                value = @"30";
            }else{
                value = @"-1";
            }
            
            [self changeWihtvalue:value];
            return;
        }
        if (!self.boolStr.boolValue) {
            if (indexPath.row == 1) {
                if (self.isFromAddFriend) {
                    [UIView animateWithDuration:0.3 animations:^{
                        [self showToastWithText:@"学友请求已发送"];
                    } completion:^(BOOL finished) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    return;
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self changeWihtvalue:@"1"];
            }
        }else{
            if (indexPath.row == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self changeWihtvalue:@"0"];
            }
        }
    }
}

- (void)changeWihtvalue:(NSString *)value{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if (self.tag == 2) {
        [self showHUD];
        [parm setValue:@"moodbook" forKey:@"settingTag"];
        [parm setValue:@"voice_visible_days" forKey:@"settingName"];
        [parm setValue:value forKey:@"settingValue"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.prisetBlock) {
                    self.prisetBlock(value);
                }
                [NoticeComTools saveSetCacha:value];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        
        return;
    }
    [parm setObject:value forKey:self.keyString];
    if (self.tag == 3) {
        if (!self.strlongitude) {
            [self showToastWithText:@"未有获取经纬度，请检查设置"];
            return;
        }
        if (value.integerValue) {
            [parm setObject:self.strlongitude forKey:@"lng"];
            [parm setObject:self.strlatitude forKey:@"lat"];
        }
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if (self.tag == 5) {//同话题
                if (self.openBlock) {
                    self.openBlock(value.boolValue);
                }
            }
            
            if (self.tag == 3 && value.integerValue) {
                if (self.openBlock) {
                    self.openBlock(YES);
                }
            }
            if ([self.keyString isEqualToString:@"strangeView"]) {
                if (self.prisetBlock) {
                    self.prisetBlock(value);
                }
                if (self.isFromAddFriend) {
                    [UIView animateWithDuration:0.3 animations:^{
                        [self showToastWithText:@"学友请求已发送"];
                    } completion:^(BOOL finished) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    return;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = self.titArr[indexPath.row];
    cell.line.hidden = (indexPath.row == self.titArr.count-1) ? YES:NO;
    if (self.tag == 3 && indexPath.row == 0) {
        cell.mainL.frame = CGRectMake(15, 13.5, 105, 14);
        cell.subL.frame = CGRectMake(15,CGRectGetMaxY(cell.mainL.frame)+10, DR_SCREEN_WIDTH-15, 14);
        cell.subL.textAlignment = NSTextAlignmentLeft;
        cell.subL.text = GETTEXTWITE(@"privacy.mark");
    }
    
    cell.subImageV.image = [UIImage imageNamed:@"setGou"];
    cell.subImageV.frame = CGRectMake(DR_SCREEN_WIDTH-10-15,(65 - 15*33/43)/2, 15, 15*33/43);
    if (self.tag == 2) {//陌生人浏览记忆和相册
        if ([self.boolStr isEqualToString:@"7"]) {
            cell.subImageV.hidden = indexPath.row == 1?NO:YES;
        }else if ([self.boolStr isEqualToString:@"30"]){
            cell.subImageV.hidden = indexPath.row == 2?NO:YES;
        }else if ([self.boolStr isEqualToString:@"0"]){
            cell.subImageV.hidden = indexPath.row == 0?NO:YES;
        }else{
           cell.subImageV.hidden = indexPath.row == 3?NO:YES;
        }
    }else{
        if (self.boolStr.boolValue) {
            if (self.tag < 2) {
                if (indexPath.row == 0) {
                    cell.subImageV.hidden = YES;
                }else{
                    cell.subImageV.hidden = NO;
                }
            }else{
                if (indexPath.row == 0) {
                    cell.subImageV.hidden = NO;
                }else{
                    cell.subImageV.hidden = YES;
                }
            }
            
        }else{
            if (self.tag < 2) {
                if (indexPath.row == 0) {
                    cell.subImageV.hidden = NO;
                }else{
                    cell.subImageV.hidden = YES;
                }
            }else{
                if (indexPath.row == 0) {
                    cell.subImageV.hidden = YES;
                }else{
                    cell.subImageV.hidden = NO;
                }
            }
        }
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    view.backgroundColor = GetColorWithName(VlistColor);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,300, 40)];
    label.text = self.headerTitle;
    if (self.tag == 2) {
        label.text = @"不是学友可以看最近多少天的心情";
    }
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //设置提示提醒用户打开定位服务
    [self showToastWithText:@"请在手机手机设置中打开应用定位"];
}

-(void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationmanager = [[CLLocationManager alloc]init];
        self.locationmanager.delegate = self;
        [self.locationmanager requestAlwaysAuthorization];
        self.currentCity = [NSString new];
        [self.locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationmanager.distanceFilter = 5.0;
        [self.locationmanager startUpdatingLocation];
    }
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    CLLocation *location = [currentLocation locationMarsFromEarth];
    self.strlatitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    self.strlongitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    if (currentLocation && currentLocation.coordinate.latitude) {
        [self.locationmanager stopUpdatingLocation];
        return;
    }
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self.currentCity = placeMark.locality;
            if (!self.currentCity) {
                self.currentCity = @"无法定位当前城市";
            }
        }
    }];
    
}

@end
