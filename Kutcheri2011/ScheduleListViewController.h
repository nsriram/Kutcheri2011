//
//  ScheduleListViewController.h
//  Kutcheri2011
//
//  Created by Sriram Narasimhan on 04/12/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tableView;
    NSArray *schedules;
    UIActivityIndicatorView *indicator;
    NSString *eventURL;
}
@property (nonatomic,retain) NSString *eventURL;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSArray *schedules;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@end
