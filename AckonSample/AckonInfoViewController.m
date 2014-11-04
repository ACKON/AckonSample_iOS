//
//  AckonInfoViewController.m
//  AckonSample
//
//  Created by Hayden on 2014. 10. 16..
//  Copyright (c) 2014년 OliveStory. All rights reserved.
//

#import "AckonInfoViewController.h"
#import <Ackon/ACKAckon.h>
@interface AckonInfoViewController ()

@end

@implementation AckonInfoViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 4;
    }else if(section==1){
        return self.ackon.actions.allKeys.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    if(indexPath.section==0){
        if(indexPath.row==0){
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.ackon.name;
        }else if(indexPath.row==1){
            cell.textLabel.text = @"UUID";
            cell.detailTextLabel.text = self.ackon.proximityUUID.UUIDString;
        }else if(indexPath.row==2){
            cell.textLabel.text = @"Major";
            cell.detailTextLabel.text = [self.ackon.major stringValue];
        }else if(indexPath.row==3){
            cell.textLabel.text = @"Minor";
            cell.detailTextLabel.text = [self.ackon.minor stringValue];
        }
    }else if(indexPath.section==1){
        cell.textLabel.text = self.ackon.actions.allKeys[indexPath.row];
        cell.detailTextLabel.text = self.ackon.actions[cell.textLabel.text];
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return @"Infomation";
    }else if(section==1){
        return @"Actions";
    }
    return nil;
}
@end
