//
//  NoticeGetPhotosFromLibary.m
//  NoticeXi
//
//  Created by li lei on 2020/12/29.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeGetPhotosFromLibary.h"

@implementation NoticeGetPhotosFromLibary

+ (NSMutableArray *)getTextArr{
    NSMutableArray *arr = [NSMutableArray new];

    NSArray *contentArr = @[@"勇于承担",
                            @"耐心对待",
                            @"认真聆听自己的内心",
                            @"灵活一点",
                            @"取决于你的选择",
                            @"笑一笑",
                            @"珍爱你的时间",
                            @"耐心一点",
                            @"大方一点",
                            @"不要被压力迫使着行事",
                            @"会有回报的",
                            @"多一点好奇",
                            @"不需要犹豫",
                            @"为什么",
                            @"真的很重要吗",
                            @"三思而后行",
                            @"方法不只一种",
                            @"你有乐观的理由",
                            @"会有人支持你",
                            @"不必压抑情绪",
                            @"带着你的善意坚持到底",
                            @"你不需要怀疑",
                            @"冷静做出最好的决定",
                            @"相信你最初的想法",
                            @"发挥你的想象力",
                            @"你有足够的时间",
                            @"一味努力未必是对的",
                            @"记得微笑",
                            @"接受改变",
                            @"你可以给自己更多信心",
                            @"鼓起勇气",
                            @"让心灵先休息一下",
                            @"保持欣喜",
                            @"听听他人的意见",
                            @"不必去等",
                            @"把这当作一次机会",
                            @"数到10，再问一次",
                            @"为什么不能兼得？",
                            @"别有顾虑",
                            @"换一个更清晰的视角",
                            @"享受这段经历",
                            @"你不需要那么多选项",
                            @"保持开明",
                            @"小心当局者迷",
                            @"越不容易，就越有价值",
                            @"把精力放在自己身上",
                            @"大声说出来",
                            @"以轻松的步伐前进",
                            @"现在你可以",
                            @"注意细节",
                            @"你需要适应",
                            @"你会拥有你需要的一切",
                            @"重点是如何解决",
                            @"适当转移你的注意力",
                            @"把握机会",
                            @"困难总会被克服",
                            @"仔细计划",
                            @"你知道的",
                            @"尽你所能",
                            @"你一定会得到支持",
                            @"找出更多办法来",
                            @"为什么不行动起来？",
                            @"节省你的精力",
                            @"你知道这很重要",
                            @"答案可能来自另一个人",
                            @"你知道你必须",
                            ];
    
    for (int i = 0; i < contentArr.count; i++) {
        NoticeBackQustionModel *model = [NoticeBackQustionModel new];
        model.content = contentArr[i];
        [arr addObject:model];
    }
    return  arr;
}

+ (NSMutableArray *)getOnlyPhotos{
    NSMutableArray *arr = [NSMutableArray new];

    // 获取所有资源的集合，并按资源的创建时间排序
    ///获取资源时的参数
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    //表示一系列的资源的集合,也可以是相册的集合
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    for (id obj in assetsFetchResults) {//获取标识符
        if (arr.count < 30) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            options.networkAccessAllowed = NO;//允许从icloud 下载
            /*
             1.Opportunistic表示尽可能的获取高质量图片
             2.HighQualityFormat表示不管花多少时间也要获取高质量的图片(慎用)
             3.FastFormat快速获取图片,(图片质量低,我们通常设置这种来获取缩略图)
             */
            options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
            
            options.resizeMode = PHImageRequestOptionsResizeModeFast;//提供精准大小的图片
            
            //创建串行队列
            @autoreleasepool {
                
                [[PHImageManager defaultManager] requestImageDataForAsset:obj options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
               
                    if (imageData) {
                        if (assetsFetchResults.count > 15) {
                            if (arr.count < 34) {
                                [arr addObject:[UIImage imageWithData:imageData]];
                            }else{
                                return;
                            }
                        }else{
                            [arr addObject:[UIImage imageWithData:imageData]];
                        }
                    }
                }];
            }
        }else{
            return arr;
        }
    }
    return arr;
}

+ (NSMutableArray *)getPhotos{
    NSMutableArray *arr = [NSMutableArray new];

    NSArray *nameArr = @[
                         @"放松感",
                         @"专注感",
                         @"快乐感",
                         @"自信感",
                         @"战胜拖延",
                         @"方向感",
                         @"自我提升",
                         @"生产力",
                         @"珍惜时间",
                         @"痛苦悔恨",
                         @"战胜无聊",
                         @"选择困难",
                         @"消灭自闭",
                         @"被人讨厌",
                         @"哲学"];
    NSArray *colorArr = @[
                         @"#46BA07",
                         @"#339BEA",
                         @"#46BA07",
                         @"#46BA07",
                         @"#339BEA",
                         @"#339BEA",
                         @"#339BEA",
                         @"#339BEA",
                         @"#46BA07",
                         @"#46BA07",
                         @"#46BA07",
                         @"#339BEA",
                         @"#46BA07",
                         @"#46BA07",
                         @"#339BEA"];
    NSArray *contentArr = @[
                            @"接下来1分钟\n做点什么会让我心情变好?",
                            @"怎么才可以让你更专注？",
                            @"你是不是把时间\n花在最让你快乐的事情上?",
                            @"你当前的什么想法\n限制了你的行动?",
                            @"你现在不立刻做这件事\n最坏的结果可能是?",
                            @"今天结束之前\n一定要做的1件事是什么?",
                            @"你怎么才能得到\n你现在所缺乏的？",
                            @"最能给你今天\n带来进展的那件事是什么?",
                            @"接下来要做的\n怎样花最少时间\n达到相同效果?",
                            @"经过这一次\n至少你知道未来\n不会走哪些弯路?",
                            @"接下来1分钟\n你可以去尝试什么新体验?",
                            @"这几个选项\n你没选哪件事会更后悔?",
                            @"10年之后，看此刻的自己\n会不会觉得很搞笑?",
                            @"讨厌你的人多了\n他算老几?",
                            @"你在做什么的时候\n会找到生命的意义?"];
    
    for (int i = 0; i < 15; i++) {
        NoticeBackQustionModel *model = [NoticeBackQustionModel new];
        model.name = nameArr[i];
        model.color = colorArr[i];
        model.content = contentArr[i];
        [arr addObject:model];
    }

    // 获取所有资源的集合，并按资源的创建时间排序
    ///获取资源时的参数
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    //表示一系列的资源的集合,也可以是相册的集合
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    for (id obj in assetsFetchResults) {//获取标识符
        if (arr.count < 34) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            options.networkAccessAllowed = NO;//允许从icloud 下载
            /*
             1.Opportunistic表示尽可能的获取高质量图片
             2.HighQualityFormat表示不管花多少时间也要获取高质量的图片(慎用)
             3.FastFormat快速获取图片,(图片质量低,我们通常设置这种来获取缩略图)
             */
            options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
            
            options.resizeMode = PHImageRequestOptionsResizeModeFast;//提供精准大小的图片
            
            //创建串行队列
            @autoreleasepool {
                
                [[PHImageManager defaultManager] requestImageDataForAsset:obj options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
               
                    if (imageData) {
                        if (assetsFetchResults.count > 15) {
                            if (arr.count < 34) {
                                [arr addObject:[UIImage imageWithData:imageData]];
                            }else{
                                return;
                            }
                        }else{
                            [arr addObject:[UIImage imageWithData:imageData]];
                        }
                    }
                }];
            }
        }else{
            return arr;
        }
    }
    return arr;
}

@end
