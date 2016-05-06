//
//  TDDynamicImg.m
//  TFB
//
//  Created by Nothing on 15/3/31.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDDynamicImg.h"

@implementation TDDynamicImg

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.fileUrl = [dictionary objectForKey:@"appimgPath"];
        self.fileDesc = [dictionary objectForKey:@"appimgDesc"];
    }
    return self;
}

@end
