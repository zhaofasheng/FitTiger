//
//  NoticeShopCommentModel.m
//  NoticeXi
//
//  Created by li lei on 2023/4/17.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopCommentModel.h"
#import "NoticeComLabelModel.h"
@implementation NoticeShopCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"comId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.intValue appointStr:@"yyyy-MM-dd hh:mm:ss"];
}

- (void)setOrder_created_at:(NSString *)order_created_at{
    _order_created_at = [NoticeTools timeDataAppointFormatterWithTime:order_created_at.intValue appointStr:@"yyyy-MM-dd hh:mm:ss"];
}

- (void)setMarks:(NSString *)marks{
    _marks = marks;
    self.marksAttTextStr = [NoticeTools getStringWithLineHight:4 string:marks];
    self.marksHeight = [NoticeTools getHeightWithLineHight:4 font:14 width:DR_SCREEN_WIDTH-60 string:marks];
}

- (void)setLabel_list:(NSArray *)label_list{
    _label_list = label_list;
    if(label_list.count){
        NSString *str = @"";
        for (NSDictionary *dic in label_list) {
            NoticeComLabelModel *model = [NoticeComLabelModel mj_objectWithKeyValues:dic];
            if(str.length){
                str = [NSString stringWithFormat:@"%@ %@",str,model.title];
            }else{
                str = model.title;
            }
        }
        self.labelAtt = [NoticeTools getStringWithLineHight:4 string:str];
        self.labelHeight = [NoticeTools getHeightWithLineHight:4 font:12 width:DR_SCREEN_WIDTH-60 string:str];
    }
}

- (void)setUserComment:(NSDictionary *)userComment{
    _userComment = userComment;
    self.userCommentModel = [NoticeShopCommentModel mj_objectWithKeyValues:userComment];
}

- (void)setShopComment:(NSDictionary *)shopComment{
    _shopComment = shopComment;
    self.shopCommentModel = [NoticeShopCommentModel mj_objectWithKeyValues:shopComment];
}
@end
