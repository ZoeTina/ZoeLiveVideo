//
//  HKLocalCacheTool.m
//  HKBicycle
//
//  Created by macy on 17/5/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HKLocalCacheTool.h"

@implementation HKLocalCacheTool

+ (NSString *)userDataDirectoryWithFileName:(NSString *)fileName
{
    NSString *bundlePath = NSHomeDirectory();
    NSString *documentsPath = [bundlePath stringByAppendingPathComponent:@"Documents"];
    NSString *userDataPath = [documentsPath stringByAppendingPathComponent:fileName];
    return userDataPath;
}

+ (void)createUserLocalDirectory:(NSString *)userDataPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory           = YES;
    NSError *error             = nil;
    
    if (![fileManager fileExistsAtPath:userDataPath isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:userDataPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
}
+ (void)removeFileWithPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
}

@end
