//
//  TabBarViewController.m
//  AckonSample
//
//  Created by Hayden on 2014. 10. 20..
//  Copyright (c) 2014년 OliveStory. All rights reserved.
//

#import "TabBarViewController.h"
#import <Ackon/Ackon.h>
@interface TabBarViewController ()<ACKServiceHelperDelegate>

@property (nonatomic, strong) ACKServiceHelper *serviceHelper;
@property (nonatomic, weak) UIViewController *permissionViewController;
@end

@implementation TabBarViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"BluetoothPermission"]){
        self.permissionViewController = segue.destinationViewController;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.serviceHelper = [[ACKServiceHelper alloc] init];//블루투스관련 객체 초기화
    self.serviceHelper.delegate = self;

    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //블루투스 on/off에 관한 이벤트
    [self.serviceHelper detectBluetooth];
    
    
    //개인정보 동의에 대한 서버통신 개인정보 동의시 호출한다
    //샘플이기때문에 유저인터렉션없이 요청합니다
    //최초1회후 요청할 필요없습니다.
}
#pragma mark ACKServiceHelperDelegate
- (void)serviceHelper:(ACKServiceHelper *)serviceHelper centralManagerDidUpdateState:(CBCentralManagerState)centralManagerState description:(NSString *)description{
    switch (centralManagerState) {
        case CBCentralManagerStatePoweredOff:
            [self performSegueWithIdentifier:@"BluetoothPermission" sender:nil];
            break;
        case CBCentralManagerStatePoweredOn:
            if(self.presentedViewController == self.permissionViewController){
                [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        case CBCentralManagerStateUnsupported:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"BluetoothLE가 지원되지 않는 기기입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
        }
            break;

        default:
            break;
    }
}
@end
