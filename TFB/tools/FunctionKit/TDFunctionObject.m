//
//  TDFunctionObject.m
//  TFB
//
//  Created by 德古拉丶 on 15/4/15.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDFunctionObject.h"
#define IMAGECACHEPATH @"IMAGECACHEPATH"

@implementation TDFunctionObject

+(NSString *)downLoadImageDirWithImageName:(NSString *)name{

    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cachesDirectory = paths[0];
   NSString *imageDir = [NSString stringWithFormat:@"%@/%@",cachesDirectory,name];
    [[NSUserDefaults standardUserDefaults] setObject:imageDir forKey:IMAGECACHEPATH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //创建轮播图文件夹
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return imageDir;

    
    
    
}
+(void)removeCacheDicContent{
    
//    删除文件夹及文件级内的文件：
    NSString * path = [[NSUserDefaults standardUserDefaults]objectForKey:IMAGECACHEPATH];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

@end
