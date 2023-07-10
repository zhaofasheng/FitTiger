//
//  NoticeVoiceListModel.h
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceListSubModel.h"
#import "NoticeMovie.h"
#import "NoticeBook.h"
#import "NoticeSong.h"
#import "NoticeZjModel.h"
#import "NoticeVoiceStatusDetailModel.h"
#import "NoticeVoiceComModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceListModel : NSObject
@property (nonatomic, strong) NSArray *first_comment;
@property (nonatomic, strong) NoticeVoiceComModel *comModel;
@property (nonatomic, strong) NSString *comment_count;
@property (nonatomic, assign) CGFloat commentHeight;
@property (nonatomic, strong) NSString *defaultImg;//默认背景图，存放于前端
@property (nonatomic, strong) NSString *resource_content;//语音转文字内容
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSString *topAt;
@property (nonatomic, strong) NSString *lastShareId;//共享ID(管理员版本使用)
@property (nonatomic, strong) NSString *is_shared;//是否已经共享过
@property (nonatomic, strong) NSString *voice_len;//声昔长度
@property (nonatomic, strong) NSString *voice_id;//声昔ID
@property (nonatomic, strong) NSString *user_id;//会话数量
@property (nonatomic, strong) NSString *voice_url;//声昔地址
@property (nonatomic, strong) NSString *voiceName;
@property (nonatomic, strong) NSString *voice_content;
@property (nonatomic, strong) NSString *content_type;
@property (nonatomic, strong) NSString *is_mark;
@property (nonatomic, strong) NSString *attr_type;
@property (nonatomic, strong) NSString *topic_id;//话题ID
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, assign) BOOL isbeiy;//备用播放
@property (nonatomic, assign) BOOL isHasAnimation;//是否执行过动画
@property (nonatomic, strong) NSString * __nullable topic_name;//话题名称
@property (nonatomic, assign) CGFloat topicHeight;//话题高度
@property (nonatomic, assign) CGFloat bgmHeight;//
@property (nonatomic, strong) NSString *topicName;//话题名称自定义
@property (nonatomic, strong) NSString *resource_type;//资源类型，0=无类型,1=影片 2书籍 3歌曲
@property (nonatomic, strong) NSString *resource_id;//资源ID
@property (nonatomic, strong) NSString *created_at;//发布时间
@property (nonatomic, strong) NSString *played_num;//播放次数
@property (nonatomic, strong) NSString *chat_num;//会话数量
@property (nonatomic, strong) NSString *chat_id;
@property (nonatomic, strong) NSString *friend_status;//好友状态，0=陌生人，1=验证中，2=已是好友
@property (nonatomic, strong) NSString *dialog_num;//对话次数
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSArray *video_url;
@property (nonatomic, strong) NSString *is_collected;//是否已经共鸣
@property (nonatomic, strong) NSDictionary *collection;
@property (nonatomic, strong) NSString *is_private;//是否私密
@property (nonatomic, strong) NSString *shared_at;//共享时间
@property (nonatomic, strong) NSString *sharedTime;//共享时间
@property (nonatomic, strong) NSString *photoTime;//相册显示时间
@property (nonatomic, strong) NSString *length_type;//1：短心情  2：长心情
@property (nonatomic, strong) NSArray *img_list;
@property (nonatomic, strong) NSArray *intersect_tags;
@property (nonatomic, strong) NoticeVoiceListSubModel *subUserModel;//user
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSString *creatTime1;
@property (nonatomic, strong) NSString *creatTime;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong) NSString *textListTime;
@property (nonatomic, strong) NSString *longTextListTime;
@property (nonatomic, assign) BOOL hasLoadIcon;//已经加载过头像
@property (nonatomic, assign) BOOL hasSetImgList;//已经设置过图片数组
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL hasRead;
@property (nonatomic, assign) BOOL canTapLike;
@property (nonatomic, strong) NSString *is_admire;//是否是互相欣赏的心情
@property (nonatomic, assign) BOOL isFromFirstGrupu;//来自哪一部分算法，在书影音列表使用的
@property (nonatomic, strong) NSString *voiceIdentity;//心情状态
@property (nonatomic, assign) BOOL isToday;//判断是否是当天发的心情
@property (nonatomic, strong) NSDictionary *movie;
@property (nonatomic, strong) NoticeMovie *  __nullable movieM;
@property (nonatomic, strong) NoticeBook *  __nullable bookM;
@property (nonatomic, strong) NoticeSong *  __nullable songM;
@property (nonatomic, strong) NoticeMovie *  __nullable scroMovieM;
@property (nonatomic, strong) NSString *user_score;
@property (nonatomic, strong) NSDictionary * __nullable resource;
@property (nonatomic, assign) BOOL isAmation;
@property (nonatomic, strong) NSString *may_interested;//可能感兴趣的人
@property (nonatomic, strong) NSString *user_gender;//1男  2女  0未知
@property (nonatomic, strong) NSString *zaned_num;
@property (nonatomic, strong) NSString *timeSgj;
@property (nonatomic, strong) NSString *is_top;//是否置顶
@property (nonatomic, strong) NSString *share_id;
@property (nonatomic, strong) NSString *scale;//第一张图片的比例(高/宽)
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *year;

@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, assign) CGFloat nowPro;

@property (nonatomic, strong) NSString *monTime;

@property (nonatomic, strong) NSString *note_num;

@property (nonatomic, strong) NSString *first_share_voice;

@property (nonatomic, strong) NSString *hide_at;//大于0表示已隐藏
@property (nonatomic, strong) NSString *voice_status;//1表示正常

@property (nonatomic, strong) NSString *be_subscribed;
@property (nonatomic, strong) NSString *subscription_id;
@property (nonatomic, strong) NSString *showText1;
@property (nonatomic, strong) NSString *totalPeople;
@property (nonatomic, strong) NSString *insterString;
@property (nonatomic, strong) NSString *recognition_content;
@property (nonatomic, strong) NSString *contentStr;//语音转文字内容
@property (nonatomic, assign) CGFloat contentWidth;//语音转文字长度
@property (nonatomic, strong) NSString *default_img;//默认图
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat titleHeight;//标题高度
@property (nonatomic, strong) NSString *title_name;
@property (nonatomic, strong) NSString *title_id;
//传统心情列表
@property (nonatomic, assign) CGFloat overContentWidth;//超出的文字长度
@property (nonatomic, assign) CGFloat moveSpeed;//滚动速度
@property (nonatomic, assign) CGFloat vlaueSpeed;
@property (nonatomic, assign) CGFloat contentLWidth;//文字可显示长度
@property (nonatomic, assign) BOOL likeNoMove;
@property (nonatomic, strong) NSString *dialog_id;

@property (nonatomic, assign) CGFloat zjContentHeight;
@property (nonatomic, strong) NSAttributedString *zjAttTextStr;

@property (nonatomic, assign) BOOL isMoreHeight;//是否超过文字详情视图高度
@property (nonatomic, assign) BOOL isMoreSYYHeight;//是否超过书影音文字详情视图高度
@property (nonatomic, assign) CGFloat moreHeight;

@property (nonatomic, strong) NSAttributedString *fiveAttTextStr;
@property (nonatomic, assign) BOOL isMoreFiveLines;//是否超过五行文字
@property (nonatomic, assign) CGFloat fiveTextHeight;//五行文字高度
@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat textBetwonHeight;//多出的文字高度
@property (nonatomic, assign) CGFloat fiveBetTextHeight;//五行文字cell高度
@property (nonatomic, strong) NSString *showText;

@property (nonatomic, assign) CGFloat rememberTextHeight;//记忆文笔高度
@property (nonatomic, assign) CGFloat rememberBetTextHeight;//记忆文笔高度
@property (nonatomic, strong) NSAttributedString *refiveAttTextStr;
@property (nonatomic, strong) NSAttributedString *reAllTextAttStr;
@property (nonatomic, assign) BOOL isReMoreFiveLines;//是否超过五行文字
@property (nonatomic, strong) NSDictionary *chat;
@property (nonatomic, strong) NSString *is_myadmire;//是否欣赏
@property (nonatomic, strong) NSString *source_type;

@property (nonatomic, strong) NSDictionary *state_info;
@property (nonatomic, strong) NoticeVoiceStatusDetailModel *statusM;

@property (nonatomic, strong) NSString *album_id;//是否加如果专辑 (已废弃)
@property (nonatomic, strong) NSArray *album;
@property (nonatomic, strong) NSMutableArray *albumArr;//心情加入了哪些专辑

@property (nonatomic, assign) BOOL hasCurrentJion;//当前已经加入当前专辑(专辑心情使用)

@property (nonatomic, assign) BOOL hasliten;//已读，加入历史记录
@property (nonatomic, assign) BOOL hasdwonloadImg;//是否加载过个性化图片
@property (nonatomic, strong) NSString *voiceNum;

@property (nonatomic, strong) NSString *reading_num;

@property (nonatomic, strong) NSString *bgm_name;//背景音乐名称

//瀑布流宽高
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat textPbheight;//瀑布流文字高度
@property (nonatomic, assign) CGFloat calculateImageHeight;//计算过图片过度后的宽高比例
@end

NS_ASSUME_NONNULL_END
