//
//  TDUseHelpTableViewController.m
//  TFB
//
//  Created by Nothing on 15/3/18.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDUseHelpTableViewController.h"
#import "TDHelpMessageTableViewController.h"
@interface TDUseHelpTableViewController ()
{
    NSArray *_textArray;
}
@end

@implementation TDUseHelpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用帮助";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HelpMessage" ofType:@"plist"];
    _textArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self backButton];
}
-(void)backButton{
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickbackButton)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}
-(void)clickbackButton{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _textArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"indent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [_textArray[indexPath.row] firstObject];
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TDHelpMessageTableViewController * helpMessageCV = [[TDHelpMessageTableViewController alloc]init];
    helpMessageCV.dataSourceArray  = [_textArray[indexPath.row] lastObject];
    [self.navigationController pushViewController:helpMessageCV animated:YES];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
