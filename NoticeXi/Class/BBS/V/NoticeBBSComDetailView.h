//
//  NoticeBBSComDetailView.h
//  NoticeXi
//
//  Created by li lei on 2020/11/12.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBBSComent.h"
#import "NoticeBBSComentInputView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBBSComDetailView : UIView<NoticeBBSComentInputDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NoticeBBSComent *comModel;
@property (nonatomic, strong) NoticeSubComentModel *subComModel;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
@property (nonatomic, assign) BOOL isFromJuBao;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) BOOL roadAll;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSString *pointComId;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger scroRow;
@property (nonatomic, strong) NSString *lastId;
- (void)show;
@end

NS_ASSUME_NONNULL_END
