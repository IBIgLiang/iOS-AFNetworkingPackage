//
//  SessionTaskListTableViewController.m
//  iOS-AFNetworking封装
//
//  Created by zhangzhiliang on 2018/11/6.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "SessionTaskListTableViewController.h"
#import "DataTaskDetailViewController.h"

@interface SessionTaskListTableViewController ()

@property (nonatomic, copy) NSString *name;

@end

@implementation SessionTaskListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",NSStringFromSelector(@selector(name)));
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"goToDataTaskDetail" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = sender;
    
    DataTaskDetailViewController *vc = segue.destinationViewController;
    
    if (![vc isKindOfClass:[DataTaskDetailViewController class]]) {
        return;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            vc.viewTitle = @"NSURLSessionDataTask";
        }
            break;
        case 1:
        {
            vc.viewTitle = @"NSURLSessionDownloadTask";
        }
            break;
            
        default:
            break;
    }
    
}

@end
