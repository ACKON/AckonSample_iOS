//
//  ServiceListViewController.h
//  AckonSample
//
//  Created by Hayden on 2014. 10. 15..
//  Copyright (c) 2014년 OliveStory. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceListViewController;
@protocol ServiceListViewControllerDelegate
- (void)serviceListViewController:(ServiceListViewController *)viewController serviceIdentifier:(NSString *)serviceIdentifer domainString:(NSString *)domainString;
@end
@interface ServiceListViewController : UITableViewController
@property (nonatomic, assign) id<ServiceListViewControllerDelegate> delegate;

@end
