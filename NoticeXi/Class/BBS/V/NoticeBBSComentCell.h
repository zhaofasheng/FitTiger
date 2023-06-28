//
//  NoticeBBSComentCell.h
//  NoticeXi
//
//  Created by li lei on 2020/11/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeBBSComent.h"
#import "NoticeManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBBSComentCell : BaseCell<LCActionSheetDelegate,NoticeManagerUserDelegate>
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *textContentLabel;
@property (nonatomic, strong) NoticeBBSComent *commentM;
@property (nonatomic, strong) NoticeBBSComent *commentTwoM;//只展示俩行文字的高度
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeNum;
@property (nonatomic, assign) BOOL showReply;
@property (nonatomic, assign) BOOL isSelfPy;//是否是自己的配音
@property (nonatomic, strong) UIView *replyView;
@property (nonatomic, strong) UILabel *subComName1L;
@property (nonatomic, strong) UILabel *subComName2L;
@property (nonatomic, strong) UILabel *moreSubComBtn;
@property (nonatomic,copy) void (^hideBlock)(BOOL hide);
@property (nonatomic,copy) void (^replyBlock)(NoticeBBSComent *commentM);
@property (nonatomic,copy) void (^replysubBlock)(NoticeSubComentModel *commentM);
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic,copy) void (^deleteBlock)(NoticeBBSComent *commentM);
@property (nonatomic,copy) void (^deleteReplyBlock)(NoticeBBSComent *commentM);
@property (nonatomic,copy) void (^deletesubBlock)(NoticeSubComentModel *commentM);
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) NoticeSubComentModel *subComModel;


@property (nonatomic, strong) UIView *tapLikeV;
@property (nonatomic, strong) NoticeBBSComent *pyCommentM;

@property (nonatomic, strong) LCActionSheet *subSheet;

@property (nonatomic, strong) UILabel *replyNickNameL;
@property (nonatomic, strong) UILabel *replyL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *sLine;
@property (nonatomic, strong) UIView *replyBackView;
@end

NS_ASSUME_NONNULL_END
