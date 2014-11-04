//
//  ServiceListViewController.m
//  AckonSample
//
//  Created by Hayden on 2014. 10. 15..
//  Copyright (c) 2014년 OliveStory. All rights reserved.
//

#import "ServiceListViewController.h"

@interface ServiceListViewController ()

@end

@implementation ServiceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate serviceListViewController:self serviceIdentifier:cell.textLabel.text domainString:cell.detailTextLabel.text];
}
@end
