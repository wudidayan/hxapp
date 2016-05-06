//
//  TDbankListName.m
//  TFB
//
//  Created by YangTao on 15/12/24.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDbankListName.h"

@implementation TDbankListName

- (instancetype)initWithDictionary:(NSDictionary *)aDic
{
    self = [super init];
    if (self) {
        
        self.cnapsCode = [aDic objectForKey:@"cnapsCode"];
        self.subBranch = [aDic objectForKey:@"subBranch"];
        
    }
    return self;
}

@end
