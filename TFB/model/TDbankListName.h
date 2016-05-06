//
//  TDbankListName.h
//  TFB
//
//  Created by YangTao on 15/12/24.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@interface TDbankListName : TDBaseModel
@property (nonatomic,strong) NSString *cnapsCode;
@property (nonatomic,strong) NSString *subBranch;



- (instancetype)initWithDictionary:(NSDictionary *)aDic;
@end
