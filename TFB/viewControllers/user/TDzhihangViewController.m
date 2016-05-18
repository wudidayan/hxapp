//
//  TDzhihangViewController.m
//  TFB
//
//  Created by YangTao on 15/12/29.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDzhihangViewController.h"

@interface TDzhihangViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TDzhihangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *table = [[UITableView alloc]init];
    table.dataSource = self;
    table.delegate = self;
    table.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-100);
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine; // UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
}

- (void)returnZhihang:(ReturnZhihangBlock)block {
    self.returnZhihangBlock = block;
}
- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.returnZhihangBlock != nil) {
        self.returnZhihangBlock(self.subBranch,self.cnapsCode);
    }
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankNameListArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier=@"reuseIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
   
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.text = [[self.bankNameListArr objectAtIndex:indexPath.row] subBranch];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.zhiHangName = [[self.bankNameListArr objectAtIndex:indexPath.row]subBranch];
    
    self.subBranch = [[self.bankNameListArr objectAtIndex:indexPath.row] subBranch];
    self.cnapsCode = [[self.bankNameListArr objectAtIndex:indexPath.row] cnapsCode];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
