//
//  AckonListViewController.m
//  AckonSample
//
//  Created by Hayden on 2014. 10. 15..
//  Copyright (c) 2014년 OliveStory. All rights reserved.
//

#import "AckonListViewController.h"
#import <Ackon/Ackon.h>
#import "AckonInfoViewController.h"
#import "TabBarViewController.h"

@interface AckonListViewController ()<ACKAckonManagerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ACKAckonManager *ackonManager;
@end

@implementation AckonListViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"AckonInfo"]){
        AckonInfoViewController *viewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ACKAckon *ackon = self.dataArray[indexPath.row];
        viewController.ackon = ackon;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    self.tableView.rowHeight = 44;
    
    //_ackonManager 를 초기화 할때 Ackon 서버 도메인과 serviceIdentifer값을 넣어 초기화 해줍니다.
    //서드파티서버를 따로 구성하지 않았을 경우 initWithServiceIdentifier: 로 초기화 해줍니다.
    //
    
    _ackonManager = [[ACKAckonManager alloc] initWithServerURL:[NSURL URLWithString:@"http://cms.ackon.co.kr/"] serviceIdentifier:@"SBA14100002"];
    self.ackonManager.delegate = self;
    //유저의 위치정보 수집 동의 후 서버에 유저 등록을 합니다.
    //유저등록은 최초에만 필수 이며 초기화 이후 필요하지 않습니다.
    [self.ackonManager requestEnabled:^(BOOL success, NSError *error) {//서비스 요청(최초 사용시 서버에서 UserID를 발급받으며 이후에는 요청하지 않습니다.
        if(success){
            [self.ackonManager allAckonWithCompletionBlock:^(NSError *error, NSArray *result) {
                [self.ackonManager startMonitoring];//모니터링 시작
                [self.ackonManager startRanging]; //ranging시작
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:result];
                [self.tableView reloadData];
            }];

        }else{
            [[[UIAlertView alloc] initWithTitle:@"실패" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil] show];
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ACKAckon *ackon = self.dataArray[indexPath.row];
    cell.textLabel.text = ackon.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"major:%@, minor:%@, %0.2fm",ackon.major, ackon.minor, ackon.accuracy];
    return cell;
}

#pragma mark ACKAckonManagerDelegate
- (void)ackonManager:(ACKAckonManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    NSLog(@"%@",region.description);
    //백그라운드에서 받을 수 있는 Delegate로 다음과 같이 UILocalNotification을 활용하여 UserInteraction을 구현 할 수 있다.
    UILocalNotification *localNotification = [UILocalNotification new];
    NSString *stateString = nil;
    switch (state) {
        case CLRegionStateInside:
            stateString = @"Inside";
            break;
        case CLRegionStateOutside:
            stateString = @"Outside";
            break;
        case CLRegionStateUnknown:
            stateString = @"Unkown";
            break;
    }
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    localNotification.alertBody = [NSString stringWithFormat:@"Beacon %@(%@,%@)", stateString,beaconRegion.major?beaconRegion.major.stringValue:@"",beaconRegion.minor.stringValue?beaconRegion.minor.stringValue:@""];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.userInfo = @{@"ViewTab": @"Log"};
    localNotification.alertAction = @"Akcon";
    localNotification.repeatInterval = 0;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void)ackonManager:(ACKAckonManager *)manager didRangeAckons:(NSArray *)ackons{
    for(ACKAckon *ackon in ackons){
        NSLog(@"%@",ackon.description);
    }
    [self.tableView reloadData];
}

- (void)ackonManager:(ACKAckonManager *)manager didError:(NSError *)error{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"오류" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alertView show];
}

@end
