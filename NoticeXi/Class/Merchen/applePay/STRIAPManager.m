
#import "STRIAPManager.h"
#import <StoreKit/StoreKit.h>
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeOpenTbModel.h"
@interface STRIAPManager()<SKPaymentTransactionObserver,SKProductsRequestDelegate>{
   NSString           *_purchID;
   IAPCompletionHandle _handle;
}
@end

@implementation STRIAPManager
 
#pragma mark - ♻️life cycle
+ (instancetype)shareSIAPManager{
     
    static STRIAPManager *IAPManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        IAPManager = [[STRIAPManager alloc] init];
    });
    return IAPManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
 
- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
 
- (NoticeActShowView *)showView{
    if (!_showView) {
        _showView = [[NoticeActShowView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _showView;
}
 
#pragma mark - public
- (void)startPurchWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle{

    self.showView.titleL.text = [NoticeTools getLocalStrWith:@"zb.pay"];
    [self.showView disMiss];
    [self.showView show];
    if (purchID) {
        
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        
        if ([purchID containsString:@"jing"]) {
            [parm setObject:purchID forKey:@"iosId"];
            [parm setObject:@"3" forKey:@"payType"];
            [parm setObject:@"2" forKey:@"platformId"];

            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopProductOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    
                    NoticeOpenTbModel *snModel = [NoticeOpenTbModel mj_objectWithKeyValues:dict[@"data"]];
                    self.sn = snModel.sn;
                    self.noteType = @"2";
                    if ([SKPaymentQueue canMakePayments]) {
                        // 开始购买服务
                        DRLog(@"开始购买%@",dict);
                        _purchID = purchID;
                        _handle = handle;
                        NSSet *nsset = [NSSet setWithArray:@[purchID]];
                        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
                        request.delegate = self;
                        [request start];
                    }else{
                        [self.showView disMiss];
                        [self handleActionWithType:SIAPPurchNotArrow data:nil];
                    }
                }else{
                    [self.showView disMiss];
                }
            } fail:^(NSError * _Nullable error) {
                [self.showView disMiss];
                [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.creatfail"]];
            }];
            return;
        }
    }
}

- (void)startPurchWithID:(NSString *)purchID money:(NSString *)money toUserId:(NSString *)userId userNum:(NSString *)userNum isNiming:(NSString *)isNiming completeHandle:(IAPCompletionHandle)handle{
    if (!purchID) {
        return;
    }
    self.showView.titleL.text = [NoticeTools getLocalStrWith:@"zb.pay"];
    [self.showView disMiss];
    [self.showView show];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:userId forKey:@"realUserId"];
    [parm setObject:[purchID  isEqualToString:@"com.gmdoc.xi"]?@"4000":money forKey:@"fee"];
    [parm setObject:purchID forKey:@"thirdGid"];
    [parm setObject:@"3" forKey:@"payType"];
    [parm setObject:@"2" forKey:@"platformId"];
    if (![purchID  isEqualToString:@"com.gmdoc.xi"]) {
        [parm setObject:userNum forKey:@"frequencyNo"];
        [parm setObject:isNiming forKey:@"isAnonymonus"];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"userOrder" Accept:@"application/vnd.shengxi.v5.2.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            NoticeOpenTbModel *snModel = [NoticeOpenTbModel mj_objectWithKeyValues:dict[@"data"]];
            self.sn = snModel.sn;
            self.noteType = @"1";
            if ([SKPaymentQueue canMakePayments]) {
                // 开始购买服务
                DRLog(@"开始购买");
                _purchID = purchID;
                _handle = handle;
                NSSet *nsset = [NSSet setWithArray:@[purchID]];
                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
                request.delegate = self;
                [request start];
            }else{
                [self.showView disMiss];
                [self handleActionWithType:SIAPPurchNotArrow data:nil];
            }
        }else{
            [self.showView disMiss];
        }
    } fail:^(NSError * _Nullable error) {
        [self.showView disMiss];
        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.creatfail"]];
    }];

}

#pragma mark - 🔒private
- (void)handleActionWithType:(SIAPPurchType)type data:(NSData *)data{
    [self.showView disMiss];
    [self.showView disMiss];
#if DEBUG
    switch (type) {
        case SIAPPurchSuccess:
            DRLog(@"%@", [NoticeTools getLocalStrWith:@"zb.buysus"]);
            break;
        case SIAPPurchFailed:
            [NoticeSaveModel clearPayInfo];
            DRLog(@"购买失败");
            break;
        case SIAPPurchCancle:
            [NoticeSaveModel clearPayInfo];
            DRLog(@"用户取消购买");//这里要删除缓存数据
            break;
        case SIAPPurchVerFailed:
            [NoticeSaveModel clearPayInfo];
            DRLog(@"订单校验失败");
            break;
        case SIAPPurchVerSuccess:
            DRLog(@"订单校验成功");
            break;
        case SIAPPurchNotArrow:
            [NoticeSaveModel clearPayInfo];
            DRLog(@"不允许程序内付费");
            break;
        default:
            break;
    }
#endif
   // NSString *receiptString= [data base64EncodedStringWithOptions:0];//转化为base64字符串

}

#pragma mark - 🍐delegate
// 交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES];
}
 
// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:SIAPPurchFailed data:nil];
    }else{
        [self handleActionWithType:SIAPPurchCancle data:nil];
    }
     
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
 
- (void)checkOrderWithOrderSn:(NSString *)sn data:(NSData *)receipt noteType:(NSString *)type transaction:(SKPaymentTransaction *)transaction{
    if (type.intValue == 2) {
        NSMutableDictionary *parm1 = [NSMutableDictionary new];
        [parm1 setObject:[receipt base64EncodedStringWithOptions:0] forKey:@"receiptData"];
        [parm1 setObject:sn forKey:@"sn"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopProductOrder/verify" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm1 page:0 success:^(NSDictionary * _Nullable dict1, BOOL success1) {
            [self.showView disMiss];
            if (success1) {
                self.sn = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
                [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.buysus"]];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }else{
                [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.fail"]];
            }
            
        } fail:^(NSError * _Nullable error) {
            [self.showView disMiss];
        }];
    }else{
        NSMutableDictionary *parm1 = [NSMutableDictionary new];
        [parm1 setObject:[receipt base64EncodedStringWithOptions:0] forKey:@"receiptData"];
        [parm1 setObject:sn forKey:@"sn"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"userOrder/verify" Accept:@"application/vnd.shengxi.v5.2.0+json" isPost:YES parmaer:parm1 page:0 success:^(NSDictionary * _Nullable dict1, BOOL success1) {
            [self.showView disMiss];
            if (success1) {
                self.sn = nil;
                if ([_purchID  isEqualToString:@"com.gmdoc.xi"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUUSERINFOFORNOTICATION" object:nil];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.buysus"]];
            }else{
                [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.fail"]];
            }
        
        } fail:^(NSError * _Nullable error) {
            [self.showView disMiss];
        }];
    }
}

- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag{
    //交易验证
    
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
     
    if(!receipt){
        // 交易凭证为空验证失败
        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }
    
    // 购买成功将交易凭证发送给服务端进行再次校验
    [self handleActionWithType:SIAPPurchSuccess data:receipt];
     
    self.showView.titleL.text = @"";
    [self.showView disMiss];
    [self.showView show];

    if (self.sn && self.sn.length > 6 && self.noteType.intValue) {
        [self checkOrderWithOrderSn:self.sn data:receipt noteType:self.noteType transaction:transaction];
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopProductOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeOpenTbModel *snModel = [NoticeOpenTbModel mj_objectWithKeyValues:dict[@"data"]];
            if (snModel.sn && snModel.sn.length > 6) {
                [self checkOrderWithOrderSn:snModel.sn data:receipt noteType:snModel.note_type transaction:transaction];
            }else{
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                DRLog(@"获取订单接口没有订单编号%@",dict);
            }
        }else{
            DRLog(@"获取订单接口请求失败%@",dict);
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [self.showView disMiss];
        }
    } fail:^(NSError * _Nullable error) {
        [self.showView disMiss];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        DRLog(@"获取订单接口请求无效%@",error);
        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.creatfail"]];
    }]; 
}
 
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] <= 0){
#if DEBUG
        DRLog(@"--------------没有商品------------------");
#endif
        return;
    }
     
    SKProduct *p = nil;
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:_purchID]){
            p = pro;
            break;
        }
    }
     
#if DEBUG
    DRLog(@"productID:%@", response.invalidProductIdentifiers);
    DRLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    DRLog(@"%@",[p description]);
    DRLog(@"%@",[p localizedTitle]);
    DRLog(@"%@",[p localizedDescription]);
    DRLog(@"%@",[p price]);
    DRLog(@"%@",[p productIdentifier]);
    DRLog(@"发送购买请求");
#endif
     
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
 
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    DRLog(@"------------------错误-----------------:%@", error);
}
 
- (void)requestDidFinish:(SKRequest *)request{
    DRLog(@"------------反馈信息结束-----------------");
}
 
#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
#if DEBUG
                DRLog(@"商品添加进列表");
#endif
                break;
            case SKPaymentTransactionStateRestored:
#if DEBUG
                DRLog(@"已经购买过商品");
#endif
                // 消耗型不支持恢复购买
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [NoticeSaveModel clearPayInfo];
                [self failedTransaction:tran];
                break;
            default:
                break;
        }
    }

}


@end
