//
//  PVUploadVideoTool.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUploadVideoTool.h"
#import "PVDBManager.h"
#import "SCImageManager.h"

@interface PVUploadVideoTool()

//@property (nonatomic, strong) SCAssetModel *assetModel;
//@property (nonatomic, strong) PVUGCVideoInfo *videoInfo;
//@property (nonatomic, strong) NSData *videoData;
@end


@implementation PVUploadVideoTool
- (void)postAssetModel:(SCAssetModel *)assetModel videoModel:(PVUGCVideoInfo *)videoInfoModel{
//    self.assetModel = assetModel;
//    self.videoInfo = videoInfoModel;
}


- (void)compressWithAssetModel:(SCAssetModel *)assetModel assetModel:(PHAsset *)asset{
    
    if ([assetModel.videoPublishState isEqualToString:@"5"]) {
        [self uploadUGCVideoInfoWithAssetModel:assetModel];
        return;
    }
    
    if (assetModel) {
        //        [[PVProgressHUD shared] showHudInView:self.view];
        dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            
            //压缩中的视频
            [self postNoticicationWithState:@"0" assetModel:assetModel];
            
            [[SCImageManager manager] getVideoOutputPathWithAsset:asset createTime:assetModel.createTime publishTime:assetModel.publishTime completion:^(NSData *videoData) { //压缩并上传
                if (videoData) {
//                    self.videoData = videoData;
                    UIImage *corverImage = [UIImage imageWithData:assetModel.corverImageData];
                    [self uploadCorverImageWithImage:corverImage AssetModel:assetModel videoData:videoData];
                    
                }else {
                    [self postNoticicationWithState:@"1" assetModel:assetModel];
                    //取消线程会崩
                    //                    dispatch_suspend(queue);
                }
            }];
        });
       
    }else {
        WindowToast(@"视频数据为空");
    }
}

/**
 上传视频封面图片
 
 @param corverImage 封面图片
 */
- (void)uploadCorverImageWithImage:(UIImage *)corverImage AssetModel:(SCAssetModel *)assetModel videoData:(NSData *)videoData{
    
    
    [self postNoticicationWithState:@"2" assetModel:assetModel];
    
    NSDictionary *dict = @{@"type":@(0),@"videoTitle":assetModel.videoTitle};
    [PVNetTool postImageWithUrl:ugcUploadFile parammeter:dict image:corverImage success:^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                assetModel.videoInfo.videoImg = [[result pv_objectForKey:@"data"] pv_objectForKey:@"url"];;
                [self uploadVideoDataWithVideoData:videoData AssetModel:assetModel];
            }else {
                WindowToast([result pv_objectForKey:@"errorMsg"]);
                [self postNoticicationWithState:@"3" assetModel:assetModel];
            }
        }else {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (dict == nil) return;
            if ([[dic pv_objectForKey:@"rs"] integerValue] == 200) {
                assetModel.videoInfo.videoImg = [[dic pv_objectForKey:@"data"] pv_objectForKey:@"url"];;
                [self uploadVideoDataWithVideoData:videoData AssetModel:assetModel];
            }else {
                WindowToast([dic pv_objectForKey:@"errorMsg"]);
                [self postNoticicationWithState:@"3" assetModel:assetModel];
            }
        }
    } failure:^(NSError *error) {
        [self postNoticicationWithState:@"3" assetModel:assetModel];
    }];
}

/**
 上传视频数据
 
 @param data 视频二进制
 */
- (void)uploadVideoDataWithVideoData:(NSData *)data AssetModel:(SCAssetModel *)assetModel{
    
    [self postNoticicationWithState:@"2" assetModel:assetModel];
    
    NSDictionary *dict = @{@"type":@(1),@"videoTitle":assetModel.videoTitle};
    
    [PVNetTool uploadVideoDataWithUrl:ugcUploadFile Parameter:dict withVideoData:data SuccessBlock:^(id responseObject) {
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                assetModel.videoInfo.videoUrl = [[responseObject pv_objectForKey:@"data"] pv_objectForKey:@"url"];
                [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp/%@", assetModel.publishTime] error:nil];
                [self uploadUGCVideoInfoWithAssetModel:assetModel];
            }else {
                [self postNoticicationWithState:@"4" assetModel:assetModel];
            }
        }
    } FailureBlock:^(NSError *error) {
        if (error) {
            [self postNoticicationWithState:@"4" assetModel:assetModel];
        }
    }];
}

- (void)uploadUGCVideoInfoWithAssetModel:(SCAssetModel *)assetModel{
    [self postNoticicationWithState:@"2" assetModel:assetModel];
    
    NSDictionary *videoINfoDict = @{@"tag":@[],@"videoDes":assetModel.videoInfo.videoDes,@"videoDuration":@(assetModel.videoInfo.videoDuration),@"videoImg":assetModel.videoInfo.videoImg,@"videoTitle":assetModel.videoInfo.videoTitle,@"videoUrl":assetModel.videoInfo.videoUrl};
    NSString *jsonStr = [videoINfoDict yy_modelToJSONString];
    NSDictionary *dict = @{@"token":huangToken,@"userId":huangUserId,@"ugcId":@(assetModel.videoInfo.ugcId),@"videoInfo":jsonStr};
    
    NSString *paraJson = [dict yy_modelToJSONString];
    
//    NSDictionary *dict = @{@"token":huangToken,@"userId":huangUserId,@"ugcId":@(assetModel.videoInfo.ugcId),@"videoInfo":assetModel.videoInfo};
    
    [PVNetTool postBodyDataURLString:postUgcInfo parameter:paraJson success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                [self postNoticicationWithState:@"6" assetModel:assetModel];
            }else {
                [self postNoticicationWithState:@"5" assetModel:assetModel];
            }
        }else {
            [self postNoticicationWithState:@"5" assetModel:assetModel];
        }
    } failure:^(NSError *error) {
        if (error) {
            [self postNoticicationWithState:@"5" assetModel:assetModel];
        }
    }];
    
    //    // 1.设置请求路径
    //       NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DynamicUrl,postUgcInfo]];//不需要传递参数
    //
    //    //    2.创建请求对象
    //       NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    //       request.timeoutInterval=5.0;//设置请求超时为5秒
    //       request.HTTPMethod=@"POST";//设置请求方法
    //
    //         //设置请求体
    //       NSString *param=[NSString stringWithFormat:@"token=%@&userId=%@&ugcId=%@&videoInfo=%@",@"jxmtkn$$ac2e38876e285ef75a81c2e8c9c96a35292790bb$$5$$1509771259804$$604800000",@"15982813546",@(self.editUgcModel.id),self.videoInfo];
    //         //把拼接后的字符串转换为data，设置请求体
    //       request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    //       [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
    //        if (connectionError == nil) {
    //            // 网络请求结束之后执行!
    //            // 将Data转换成字符串
    //            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        }
    //    }];
}

// 视频上传状态， 0:压缩中，1:压缩失败，2:上传中，3:封面图上传失败，4.封面图上传成功，视频上传失败 5:视频上传成功，但是其他视频信息上传失败,6:上传成功
- (void)postNoticicationWithState:(NSString *)state assetModel:(SCAssetModel *)assetModel{
    assetModel.videoPublishState = state;
    assetModel.videoInfoData = [assetModel.videoInfo yy_modelToJSONData];
    
    if (assetModel.videoInfoData) {
        if ([[PVDBManager sharedInstance] insertShortVideoModelWithModel:assetModel]) {
            if ([state isEqualToString:@"6"]) {
                if ([[PVDBManager sharedInstance] deleteShortVideoModelWithData:assetModel]) {
                    WindowToast(@"视频发布成功，等待审核结果");
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVideoState" object:nil];
        }
        
        
    }
    
    
}
@end
