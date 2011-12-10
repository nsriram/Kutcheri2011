#import "ScheduleCell.h"
#import <EventKit/EventKit.h>

@implementation ScheduleCell
@synthesize when,what,where;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) showAlert:(NSString*) title message: (NSString*) message{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)addSchedule :(UIButton *)sender{
    NSMutableString *subs =  [NSMutableString stringWithString:when.text];
    NSRange dateRange = [subs rangeOfString: @"@"];
    
    NSString *dateValue = [subs substringToIndex:(dateRange.location - 1)];
    NSString *timeDuration = [subs substringFromIndex:(dateRange.location +2)];
    
    NSRange timeRange = [timeDuration rangeOfString: @"-"];
    NSString *startTime = [timeDuration substringToIndex:(timeRange.location)];
    NSString *endTime = [timeDuration substringFromIndex:(timeRange.location+1)];        

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm aaa"];

    NSDate *startDate = [dateFormatter dateFromString:[dateValue stringByAppendingFormat:@" %@",[startTime uppercaseString]]];
    
    NSDate *endDate = [dateFormatter dateFromString:[dateValue stringByAppendingFormat:@"%@",[endTime uppercaseString]]];

    EKEventStore *eventStore = [[EKEventStore alloc]init]; 
    EKCalendar *defautCalendar = [eventStore defaultCalendarForNewEvents];

    if (!defautCalendar){
        [self showAlert:@"Event not created" message:@"There is no default calendar."];
        return;
    }

    EKEvent *kutcheriEvent  = [EKEvent eventWithEventStore:eventStore];
    kutcheriEvent.title     = what.text;
    kutcheriEvent.startDate = startDate;
    kutcheriEvent.endDate   = endDate;
    kutcheriEvent.allDay = NO;

    NSMutableArray *reminders = [[NSMutableArray alloc] init];
    EKAlarm *reminder1 = [EKAlarm alarmWithRelativeOffset:-7200];
    EKAlarm *reminder2 = [EKAlarm alarmWithRelativeOffset:-86400];
    
    [reminders addObject:reminder1];
    [reminders addObject:reminder2];
    kutcheriEvent.alarms = reminders;

    [kutcheriEvent setCalendar:defautCalendar];

    NSError *err = nil;    
    BOOL result = NO;
    result = [eventStore saveEvent:kutcheriEvent span:EKSpanThisEvent error:&err];

    if (result == NO) {
        NSLog(@"%@ %@",err, [err userInfo]);
        [self showAlert:@"Event not created" message:@"Sorry, event could not be created."];
    }else {
        [self showAlert:@"Event Created" message:@"Event created with reminders 2Hours before, 1Day before."];
    }
}

@end
