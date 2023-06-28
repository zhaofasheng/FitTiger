//
//  NoticeWhiteVoiceListModel.h
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeWhiteVoiceListModel : NSObject
@property (nonatomic, strong) NSString *card_id;
@property (nonatomic, strong) NSString *card_no;
@property (nonatomic, strong) NSString *card_num;
@property (nonatomic, strong) NSString *card_status;
@property (nonatomic, strong) NSString *card_url;
@property (nonatomic, strong) NSString *audio_url;
@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *banner_url;
@property (nonatomic, strong) NSString *total_num;
@property (nonatomic, strong) NSString *total_type;
@property (nonatomic, strong) NSString *card_intro;
@property (nonatomic, strong) UIImage  *titleImage;
@property (nonatomic, strong) NSString *card_title;
@property (nonatomic, strong) NSString *card_author;
@property (nonatomic, strong) NSString *backColor;
@property (nonatomic, strong) NSString *textColor;
@property (nonatomic, strong) NSString *background_url;
@property (nonatomic, strong) NSString *first_card_no;
@property (nonatomic, strong) NSString *receive_status;//1未领取，2已领取，3失效
@property (nonatomic, strong) NSString *first_card_url;
@property (nonatomic, assign) BOOL isChoiceed;
@end

NS_ASSUME_NONNULL_END
