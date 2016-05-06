//
//  TDHelpMessageTableViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/7.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDHelpMessageTableViewController.h"

@interface TDHelpMessageTableViewController (){

    UILabel * _label;
    NSMutableArray * _dataArray;
    NSMutableArray * _dataSourceArr;
    UITableView * _cell;
}

@end

@implementation TDHelpMessageTableViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商户问答";
    self.tableView.separatorColor = [UIColor whiteColor];
    if (!_dataArray ) {
        _dataArray = [NSMutableArray arrayWithCapacity:5];
    }
    _dataSourceArr  =[NSMutableArray arrayWithCapacity:5];
    
    for (int i = 0; i < _dataSourceArray.count; i++ ) {
        [_dataArray addObject:@{@"cell":@"mian",@"status":@NO}];
        [_dataSourceArr addObject:[_dataSourceArray[i] firstObject]];
    }
    [self.tableView reloadData];
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
-(void)viewWillAppear:(BOOL)animated{



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _dataSourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       

    return [self contextHighWithContext:_dataSourceArr[indexPath.row]]+10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
   
     cell.textLabel.numberOfLines = 0;
     cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    if ([[_dataArray[indexPath.row] objectForKey:@"cell"] isEqualToString:@"sub"]) {
        cell.textLabel.text  = _dataSourceArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
    }else{
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text  = _dataSourceArr[indexPath.row];
     cell.backgroundColor = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];
    
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath * path = nil;
    
    if ([[_dataArray[indexPath.row] objectForKey:@"cell"] isEqualToString:@"mian"]) {
        path = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        _cell = (UITableView *)[tableView cellForRowAtIndexPath:indexPath];
    }else{
        path = indexPath;
    }
    
    if ([[_dataArray[indexPath.row] objectForKey:@"status"] isEqualToNumber:@NO]) { //添加
        NSDictionary * d = @{@"cell":@"sub",@"status":@YES};
        if ([_dataArray isKindOfClass:[NSMutableArray class]]) {
            [_dataArray insertObject:d atIndex:path.row];
        }else{
            return;
        }
        NSString * string = @"";
        for (NSArray * arr in _dataSourceArray) {
            if ([[arr firstObject] isEqualToString:[tableView cellForRowAtIndexPath:indexPath].textLabel.text]) {
                string = [arr lastObject];
                break;
            }
        }
        [_dataSourceArr insertObject:string atIndex:path.row];
        _dataArray[indexPath.row] = @{@"cell":@"mian",@"status":@YES};
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
    }else{// 删除
        
        _dataArray[path.row-1] = @{@"cell":@"mian",@"status":@NO};
        [_dataArray removeObjectAtIndex:path.row];
        [_dataSourceArr removeObjectAtIndex:path.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(float)contextHighWithContext:(NSString *)context{
    
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _label.font = [UIFont systemFontOfSize:14.0f];
        _label.numberOfLines = 0;
        _label.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    _label.text = context;
    [_label sizeToFit];
    return _label.frame.size.height;
    
}

@end
