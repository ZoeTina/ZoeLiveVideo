//
//  PVNetTool.h
//  PandaVideo
//
//  Created by cara on 17/9/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVNetModel;

@interface PVNetTool : NSObject

+(void)cancelCurrentRequest;
+(void)invalidateCancelingRequest;


/**
 *   用于单个接口进行get网络请求,只能用于json格式数据请求，否则报错
 *
 *  @param url         get进行网络请求的链接
 *  @param success     请求成功后数据回调
 *  @param failure     请求失败进行返回出去
 */
+ (void)getDataWithUrl:(NSString *)url   success:(void (^)( id result))success failure:(void (^)(NSError *error))failure;

/**
 *   用于单个接口进行post网络请求,只能用于json格式数据请求，否则报错
 *
 *  @param params      post进行网络请求的参数
 *  @param url         post进行网络请求的链接
 *  @param success     请求成功后数据回调
 *  @param failure     请求失败进行返回出去
 */
+ (void)postDataWithParams:(NSDictionary*)params  url:(NSString*)url success:(void (^)( id result))success failure:(void (^)(NSError *error))failure;


/**
 带有token的单个接口进行post网络请求,只能用于json格式数据请求，否则报错

 @param params post进行网络请求的参数
 @param url post进行网络请求的链接
 @param success 请求成功后数据回调
 @param failure 请求失败进行返回出去
 @param tokenErrorInfo token相关失败信息
 */
+ (void)postDataHaveTokenWithParams:(NSDictionary *)params url:(NSString *)url success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure tokenErrorInfo:(void (^)(NSString *tokenErrorInfo))tokenErrorInfo;

#pragma mark 一个页面多个get和post请求
/**
 *  对get和post进行多个请求
 *
 *  @param params  请求的参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */

+ (void)getMoreDataWithParams:(NSArray<PVNetModel*> *)params success:(void (^)(id result))success failure:(void (^)(NSArray *errors))failure;

/**
 上传头像

 @param url 请求url
 @param dict 请求参数
 @param image 上传图片
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (void)postImageWithUrl:(NSString *)url parammeter:(NSDictionary *)dict image:(UIImage *)image success:(void (^)( id result))success failure:(void (^)(NSError *error))failure;


/**
 上传照片数组

 @param url 上传照片url
 @param dict 参数
 @param imageArray 照片数组
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)postImageArrayWithUrl:(NSString *)url parammeter:(NSDictionary *)dict image:(NSArray *)imageArray success:(void (^)(NSArray *result))success failure:(void (^)(NSArray *errorResult))failure;
/**
 *  Get 请求
 *
 *  @param URLString URLString
 *  @param parameter 参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+(void)getWithURLString:(NSString *)URLString
              parameter:(NSDictionary *)parameter
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;


/**
 *  Post 请求
 *
 *  @param URLString URL
 *  @param parameter 参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+(void)postWithURLString:(NSString *)URLString
               parameter:(NSDictionary *)parameter
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;


/*上传视频方法的参数
 1. appendPartWithFileData：要上传的照片[二进制流]
 2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
 3. fileName：要保存在服务器上的文件名
 4. mimeType：上传的文件的类型
 */
+ (void)uploadVideoDataWithUrl:(NSString *)url Parameter:(NSDictionary *)dictionary
                 withVideoData:(NSData *)videoData
                  SuccessBlock:(void(^)(id responseObject))success
                  FailureBlock:(void(^)(NSError *error))failure;




/**
 将参数放在body里以json格式请求

 @param URLString url
 @param param 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)postBodyDataURLString:(NSString *)URLString parameter:(NSString *)param success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;


/**
 将参数放在body里的多个请求

 @param params 请求数组
 @param success 成功回调数组
 @param failure 失败回调数组
 */
+ (void)checkMoreOrderDataWithParams:(NSArray<PVNetModel*> *)params productIdArray:(NSArray *)productIdArray success:(void (^)(NSArray *result))success failure:(void (^)(NSArray *errors))failure;
@end
