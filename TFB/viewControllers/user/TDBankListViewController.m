//
//  TDBankListViewController.m
//  TFB
//
//  Created by YangTao on 15/12/29.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDBankListViewController.h"
#import "TDBindBankCardViewController.h"
@interface TDBankListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TDBankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *table = [[UITableView alloc]init];
    table.dataSource = self;
    table.delegate = self;
    table.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-100);
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
}

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(self.bankNameButton);
    }
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier=@"reuseIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    cell.textLabel.text = self.bankArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.bankNameButton = self.bankArr[indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
