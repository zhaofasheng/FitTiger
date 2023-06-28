//
//  NoticeVoiceSaveModel.h
//  NoticeXi
//
//  Created by li lei on 2019/5/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceSaveModel : NSObject
@property (nonatomic, strong) NSString *pathName;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) NSString *voiceTimeLen;
@property (nonatomic, strong) NSString *voiceFilePath;
@property (nonatomic, strong) NSString *img1Path;
@property (nonatomic, strong) NSString *img2Path;
@property (nonatomic, strong) NSString *img3Path;
@property (nonatomic, strong) NSString *img1;
@property (nonatomic, strong) NSString *img2;
@property (nonatomic, strong) NSString *img3;
@property (nonatomic, strong) NSString *jsonImg1;
@property (nonatomic, strong) NSString *jsonImg2;
@property (nonatomic, strong) NSString *jsonImg3;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *topName;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, strong) NSString *voiceType;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *songId;
@property (nonatomic, strong) NSString *movieId;
@property (nonatomic, strong) NSString *resourceType;
@property (nonatomic, strong) NSString *stateId;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *voiceIdentity;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSAttributedString *fiveAttTextStr;
@property (nonatomic, assign) BOOL isMoreFiveLines;//是否超过五行文字
@property (nonatomic, assign) CGFloat fiveTextHeight;//五行文字高度
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSString *showText;
- (void)getData;
@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, assign) CGFloat nowPro;
@end

NS_ASSUME_NONNULL_END
