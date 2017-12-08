//
//  PVNetTool.m
//  PandaVideo
//
//  Created by cara on 17/9/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVNetTool.h"
#import "AFNetworking.h"
#import "AFSessionManager.h"

static AFHTTPSessionManager* manager_ = nil;


@implementation PVNetTool

+(void)cancelCurrentRequest{
    [manager_.tasks makeObjectsPerformSelector:@selector(cancel)];
    
}
+(void)invalidateCancelingRequest{
    [manager_ invalidateSessionCancelingTasks:true];
}


#pragma mark 一个页面单个get请求
+ (void)getDataWithUrl:(NSString *)url   success:(void (^)( id result))success failure:(void (^)(NSError *error))failure{
    
    NSString* getUrl = [NSString stringWithFormat:@"%@%@",BASEURL,url];
    getUrl = [getUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    getUrl = [getUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if(getUrl.length == 0)return;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error && failure) {
            failure(error);
        }
    }];
}

#pragma mark 一个页面单个post请求
+ (void)postDataWithParams:(NSDictionary*)params  url:(NSString*)url success:(void (^)( id result))success failure:(void (^)(NSError *error))failure{
    
    if(url.length == 0)return;
    
    NSString* postUrl = [NSString stringWithFormat:@"%@/%@",DynamicUrl,url];
    postUrl = [postUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    postUrl = [postUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [manager POST:postUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error && failure) {
            failure(error);
        }
    }];
}

+ (void)postDataHaveTokenWithParams:(NSDictionary *)params url:(NSString *)url success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure tokenErrorInfo:(void (^)(NSString *tokenErrorInfo))tokenErrorInfo {
    
    if ([[params allKeys] containsObject:@"token"]) {
        NSString *token = params[@"token"];
        if (token.length == 0) {
            tokenErrorInfo(@"token为空");
            return;
        }
    }
    if (url.length == 0) return;
    
    NSString* postUrl = [NSString stringWithFormat:@"%@%@",DynamicUrl,url];
    postUrl = [postUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    postUrl = [postUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10];
    manager_ = manager;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [manager POST:postUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}


#pragma mark 一个页面多个get和post请求
/**
 *  对get和post进行多个请求
 *
 *  @param params  请求的参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */

+ (void)getMoreDataWithParams:(NSArray<PVNetModel*> *)params success:(void (^)(id result))success failure:(void (^)(NSArray *errors))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    ///返回的json数组
    NSMutableArray * resultArr = [NSMutableArray arrayWithCapacity:params.count];
    ///返回的error
    NSMutableArray* errorArr = [NSMutableArray array];
    
    dispatch_group_t group = dispatch_group_create();
    
    //根据params进行开辟线程请求，遍历数组params
    [params enumerateObjectsUsingBlock:^(PVNetModel* netModel, NSUInteger index, BOOL *stop) {
        
        //把索引转成对象
        NSString * indexNumber = [[NSString alloc] initWithFormat:@"%ld",(unsigned long)index];
        netModel.url = [netModel.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* getUrl = [netModel.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        if(getUrl.length == 0){
            NSDictionary * jsonDict = @{indexNumber:@"NODATA"};
            [resultArr addObject:jsonDict];
        }else{
            // 将当前的下载操作添加到组中
            dispatch_group_enter(group);
            if (netModel.isGetOrPost) {//get
                //执行网络请求
                [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (success) {
                        //保存调用结果
                        NSDictionary * jsonDict = @{indexNumber:responseObject};
                        [resultArr addObject:jsonDict];
                    }
                    // 离开当前组
                    dispatch_group_leave(group);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                    if (error) {
                        //保存调用的error
                        NSError * errorDict = error;
                        [errorArr addObject:errorDict];
                    }
                    // 离开当前组
                    dispatch_group_leave(group);
                }];
            }
            else{//post
                [manager POST:getUrl parameters:netModel.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (success) {
                        //保存调用结果
                        NSDictionary * jsonDict = @{indexNumber:responseObject};
                        [resultArr addObject:jsonDict];
                    }
                    // 离开当前组
                    dispatch_group_leave(group);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (error) {
                        //保存调用的error
                        NSError * errorDict = error;
                        [errorArr addObject:errorDict];
                    }
                    // 离开当前组
                    dispatch_group_leave(group);
                }];
            }
        }
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //回调主线程，返回数据
        if (resultArr.count < 1) {
            failure(errorArr);
        }else{
            //用于成功回调json数据
            NSMutableDictionary *resutJsonDict = [NSMutableDictionary dictionaryWithCapacity:resultArr.count];
            for (int i=0; i<resultArr.count; i++){
//                NSString * indexStr = [NSString stringWithFormat:@"%d",i];
                NSDictionary * jsonDict = [resultArr sc_safeObjectAtIndex:i];
                [resutJsonDict addEntriesFromDictionary:jsonDict];
//                for (NSDictionary * jsonDict in resultArr) {
//                    if ([jsonDict.allKeys.firstObject isEqualToString:indexStr] ) {
//                        [resutJsonDict setObject:jsonDict[indexStr] forKey:indexStr];
//                        continue;
//                    }
//                }
            }
            success(resutJsonDict);
        }
    });
}

+ (void)postImageWithUrl:(NSString *)url parammeter:(NSDictionary *)dict image:(UIImage *)image success:(void (^)( id result))success failure:(void (^)(NSError *error))failure {
    AFSessionManager *manager = [AFSessionManager shareInstance];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *totalUrl = [NSString stringWithFormat:@"%@%@", DynamicUrl, url];
    [manager POST:totalUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image,0.5);//把要上传的图片转成NSData
        
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", dateString];
        if (data == nil) return;
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)postImageArrayWithUrl:(NSString *)url parammeter:(NSDictionary *)dict image:(NSArray *)imageArray success:(void (^)(NSArray *result))success failure:(void (^)(NSArray *errorResult))failure {
    AFSessionManager *manager = [AFSessionManager shareInstance];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *totalUrl = [NSString stringWithFormat:@"%@%@", DynamicUrl, url];
    
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:imageArray.count];
    NSMutableArray *errorArr = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    [imageArray enumerateObjectsUsingBlock:^(UIImage *postImage, NSUInteger index, BOOL * _Nonnull stop) {
        dispatch_group_enter(group);
        //把索引转成对象
        NSString * indexNumber = [[NSString alloc] initWithFormat:@"%ld",(unsigned long)index];
        [manager POST:totalUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *data = UIImageJPEGRepresentation(postImage,0.5);//把要上传的图片转成NSData
            
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", dateString];
            if (data == nil) return;
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject) {
                
                if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
//                    NSDictionary * jsonDict = @{indexNumber:[[responseObject pv_objectForKey:@"data"] pv_objectForKey:@"url"]};
                    NSString *url = [[responseObject pv_objectForKey:@"data"] pv_objectForKey:@"url"];
                    [resultArr addObject:url];
                }
                
            }
            dispatch_group_leave(group);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error) {
                //保存调用的error
                NSError * errorDict = error;
                [errorArr addObject:errorDict];
            }
            // 离开当前组
            dispatch_group_leave(group);
        }];
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //回调主线程，返回数据
        success(resultArr);
        failure(errorArr);
//        if (resultArr.count < 1) {
//            failure(errorArr);
//        }else{
//            //用于成功回调json数据
//            NSMutableDictionary *resutJsonDict = [NSMutableDictionary dictionaryWithCapacity:resultArr.count];
//            for (int i=0; i<resultArr.count; i++){
//
//                NSDictionary * jsonDict = [resultArr sc_safeObjectAtIndex:i];
//                [resutJsonDict addEntriesFromDictionary:jsonDict];
//            }
//            success(resutJsonDict);
//        }
    });
    
}


/**
 *  Get 请求
 *
 *  @param URLString URLString
 *  @param parameter 参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+(void)getWithURLString:(NSString *)URLString parameter:(NSDictionary *)parameter success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString *getUrl = [NSString stringWithFormat:@"%@/%@",DynamicUrl,URLString];
    getUrl = [getUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    

    //    NSString *userAgent = [NSString stringWithFormat:@"iOS/%@/2.15.0",[[UIDevice currentDevice] name]];
    //    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    // 判断是否登录
    //    YYUserLoginModel *loginModel = [YYUserLoginModel sharedUserLoginModel];
    //    if ([YYUserLoginModel sharedUserLoginModel].isLogin) {
    //
    //        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:loginModel.uid
    //                                                                  password:loginModel.token];
    //    }else{
    
    //        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"0.0.0.0" password:@"tuicool"];
    //    }
    
    
    [manager GET:getUrl parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
}

/**
 *  Post 请求
 *
 *  @param URLString URLString
 *  @param parameter 参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+(void)postWithURLString:(NSString *)URLString parameter:(NSDictionary *)parameter success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    
    NSString *postUrl = [NSString stringWithFormat:@"%@/%@",DynamicUrl,URLString];
    postUrl = [postUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    //    NSString *userAgent = [NSString stringWithFormat:@"iOS/%@/2.15.0",[[UIDevice currentDevice] name]];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    //    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"0.0.0.0" password:@"tuicool"];
    //    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:postUrl parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

/*该方法的参数
 1. appendPartWithFileData：要上传的照片[二进制流]
 2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
 3. fileName：要保存在服务器上的文件名
 4. mimeType：上传的文件的类型
 */
+ (void)uploadVideoDataWithUrl:(NSString *)url Parameter:(NSDictionary *)dictionary
                       withVideoData:(NSData *)videoData
                        SuccessBlock:(void(^)(id responseObject))success
                        FailureBlock:(void(^)(NSError *error))failure {
    
    AFSessionManager *manager = [AFSessionManager shareInstance];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *stringURL = [NSString stringWithFormat:@"%@%@", DynamicUrl, url];
    
    [manager POST:stringURL parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", dateString];
        
        /**
         * 拼接创建 fromData
         * param data 二进制文件
         * param name 服务器接受数据的字段名
         * param fileName 保存在服务器上的文件名
         * param mimeType 上传文件类型
         */
        if (videoData == nil) return;
        [formData appendPartWithFileData:videoData name:@"file" fileName:fileName mimeType:@"video/mpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgress) {
//            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


/**
 将参数放在body里以json格式请求
 
 @param URLString url
 @param param 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)postBodyDataURLString:(NSString *)URLString parameter:(NSString *)param success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; //不设置会报-1016或者会有编码问题
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //不设置会报-1016或者会有编码问题
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //不设置会报 error 3840
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",DynamicUrl,URLString] parameters:nil error:nil];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *body  =[param dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:body];
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }
        if (responseObject) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            success(dic);
        }
        
    }] resume];
}

/**
 将参数放在body里的多个请求
 
 @param params 请求数组
 @param success 成功回调数组
 @param failure 失败回调数组
 */
+ (void)checkMoreOrderDataWithParams:(NSArray<PVNetModel*> *)params productIdArray:(NSArray *)productIdArray success:(void (^)(NSArray *result))success failure:(void (^)(NSArray *errors))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; //不设置会报-1016或者会有编码问题
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //不设置会报-1016或者会有编码问题
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //不设置会报 error 3840
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:params.count];
    NSMutableArray *errorArr = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    
    [params enumerateObjectsUsingBlock:^(PVNetModel * netModel, NSUInteger index, BOOL * _Nonnull stop) {
        //把索引转成对象
        NSString * indexNumber = [[NSString alloc] initWithFormat:@"%ld",(unsigned long)index];
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",DynamicUrl,netModel.url] parameters:nil error:nil];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSData *body  =[netModel.postData dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
        
        dispatch_group_enter(group);
        
        [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                //保存调用的error
                NSError * errorDict = error;
                if (errorDict) {
                    NSString *productId = [productIdArray sc_safeObjectAtIndex:index];
                    NSDictionary * jsonDict = @{@"productId":productId,@"error":errorDict};
                    [errorArr addObject:jsonDict];
                }
               
                dispatch_group_leave(group);
            }
            if (responseObject) {
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if (dic) {
                    NSString *productId = [productIdArray sc_safeObjectAtIndex:index];
                    //                NSDictionary * jsonDict = @{productId:dic};
                    [dic setObject:productId forKey:@"productId"];
                    [resultArr addObject:dic];
                }
                
                dispatch_group_leave(group);
            }
            
        }] resume];
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //回调主线程，返回数据
        success(resultArr);
        failure(errorArr);
    });
    
    
    
}
@end
