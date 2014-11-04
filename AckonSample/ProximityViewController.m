//
//  ProximityViewController.m
//  AckonSample
//
//  Created by Hayden on 2014. 10. 22..
//  Copyright (c) 2014년 OliveStory. All rights reserved.
//

#import "ProximityViewController.h"
#import <Ackon/Ackon.h>
#import "AckonInfoViewController.h"
#import "TabBarViewController.h"


@interface ProximityViewController ()<ACKAckonManagerDelegate>
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) NSMutableSet *cachedAckons;
@property (nonatomic, strong) ACKAckonManager *ackonManager;
@property (nonatomic, strong) NSArray *sectionArray;

@end

@implementation ProximityViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"AckonInfo"]){
        AckonInfoViewController *viewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSArray *array = self.data[self.sectionArray[indexPath.section]];
        ACKAckon *ackon = array[indexPath.row];
        viewController.ackon = ackon;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sectionArray = @[@(CLProximityImmediate),@(CLProximityNear), @(CLProximityFar), @(CLProximityUnknown)];
    self.data = [NSMutableDictionary new];
    self.cachedAckons = [NSMutableSet new];
    for(NSNumber *number in self.sectionArray){
        [self.data setObject:[NSMutableArray new] forKey:number];
    }
    self.tableView.rowHeight = 44;
    
    //UI 업데이트를 업데이트하도록 스캐쥴을 등록합니다.
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateAckonList:) userInfo:nil repeats:YES];
    [timer fire];
    //초기화
    _ackonManager = [[ACKAckonManager alloc] initWithServerURL:[NSURL URLWithString:@"http://cms.ackon.co.kr/"] serviceIdentifier:@"SBA14100002"];
    self.ackonManager.delegate = self;//델리게이트를 꼭 할당해주세요
    [self.ackonManager requestEnabled:^(BOOL success, NSError *error) {//권한 요청합니다.
        if(success){
            [self.ackonManager allAckonWithCompletionBlock:^(NSError *error, NSArray *result) {//ackon리스트를 받아옵니다.
                [self.ackonManager startRanging];//ranging을 시작합니다.- (void)ackonManager:(ACKAckonManager *)manager didRangeAckons:(NSArray *)ackons 에서 확인해주세요

            }];
            
        }else{
            [[[UIAlertView alloc] initWithTitle:@"실패" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil] show];
        }
    }];

}

//UI업데이트
- (void)updateAckonList:(id)sender{
    
    //섹션별 배열을 비웁니다.
    for(NSNumber *number in self.sectionArray){
        NSMutableArray *array = self.data[number];
        [array removeAllObjects];
    }
    //섹션에 맞게 ackon들을 추가합니다.
    for(ACKAckon *ackon in self.cachedAckons){
        NSMutableArray *results = self.data[@(ackon.proximity)];
        [results addObject:ackon];
    }
    //캐쉬된 ackons들을 비웁니다.
    
    [self.cachedAckons removeAllObjects];
    //화면 업데이트
    [self.tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *result = self.data[self.sectionArray[section]];
    return result.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    CLProximity proximity = (CLProximity)[self.sectionArray[section] intValue];
    switch (proximity) {
        case CLProximityFar:
            return @"CLProximityFar";
        case CLProximityUnknown:
            return @"CLProximityUnknown";
        case CLProximityImmediate:
            return @"CLProximityImmediate";
        case CLProximityNear:
            return @"CLProximityNear";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *array = self.data[self.sectionArray[indexPath.section]];
    ACKAckon *ackon = array[indexPath.row];
    cell.textLabel.text = ackon.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"major:%@, minor:%@, %0.2fm",ackon.major, ackon.minor, ackon.accuracy];
    return cell;
}
#pragma mark ACKAckonManagerDelegate
- (void)ackonManager:(ACKAckonManager *)manager didRangeAckons:(NSArray *)ackons{
    // ackon을 셋에 담습니다.
    [self.cachedAckons addObjectsFromArray:ackons];
}
- (void)ackonManager:(ACKAckonManager *)manager didError:(NSError *)error{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"오류" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alertView show];
}
@end
