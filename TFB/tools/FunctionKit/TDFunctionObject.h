//
//  TDFunctionObject.h
//  TFB
//
//  Created by 德古拉丶 on 15/4/15.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFunctionObject : NSObject

//创建轮播图文件夹
+(NSString *)downLoadImageDirWithImageName:(NSString *)name;
//删除轮播图文件夹内容  //不做清除缓存的话就用不到
+(void)removeCacheDicContent;

@end
