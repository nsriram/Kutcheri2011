//
//  ScheduleCell.h
//  Kutcheri2011
//
//  Created by Sriram Narasimhan on 04/12/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCell : UITableViewCell{
    IBOutlet UILabel *when;
    IBOutlet UILabel *where;
    IBOutlet UILabel *what;
}
@property (nonatomic,retain) UILabel *when;
@property (nonatomic,retain) UILabel *where;
@property (nonatomic,retain) UILabel *what;
-(IBAction)addSchedule :(UIButton *)sender;
@end
