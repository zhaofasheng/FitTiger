//
//  NoticeMyShopModel.m
//  NoticeXi
//
//  Created by li lei on 2022/7/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyShopModel.h"
#import "NoticeComLabelModel.h"
@implementation NoticeMyShopModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"shopId":@"id"};
}

- (void)setShop:(NSDictionary *)shop{
    _shop = shop;
    self.myShopM = [NoticeMyShopModel mj_objectWithKeyValues:shop];
}

- (void)setRole_list:(NSArray *)role_list{
    _role_list = role_list;
    if (role_list.count) {
        self.role_listArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in role_list) {
            NoticeMyShopModel *roleM = [NoticeMyShopModel mj_objectWithKeyValues:dic];
            [self.role_listArr addObject:roleM];
        }
        
    }
}

- (void)setGoods_list:(NSMutableArray *)goods_list{
    _goods_list = goods_list;
    if (goods_list.count) {
        self.goods_listArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in self.goods_list) {
            NoticeGoodsModel *goodM = [NoticeGoodsModel mj_objectWithKeyValues:dic];
            [self.goods_listArr addObject:goodM];
        }
    }
}

- (void)setTexts:(NSDictionary *)texts{
    _texts = texts;
    self.textModel = [NoticeMyShopModel mj_objectWithKeyValues:texts];
}

- (void)setLabel_list:(NSArray *)label_list{
    _label_list = label_list;
    
    if(label_list.count){
        self.labelArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in label_list) {
            NoticeComLabelModel *comM = [NoticeComLabelModel mj_objectWithKeyValues:dic];
            if(comM.num.intValue){
                comM.showStr = [NSString stringWithFormat:@"%@ +%@",comM.title,comM.num];
            }else{
                comM.showStr = comM.title;
            }
            
            comM.showStrWidth = GET_STRWIDTH(comM.showStr, 14, 20);
            [self.labelArr addObject:comM];
        }
    }
}
@end
