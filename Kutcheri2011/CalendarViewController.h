#import <UIKit/UIKit.h>
#import "DateEventsViewController.h"

@interface CalendarViewController : UIViewController{
    DateEventsViewController *dateEventsViewController;
}
@property (nonatomic,retain) DateEventsViewController *dateEventsViewController;
-(IBAction) daySelected:(UIButton *)button;
-(IBAction) janDaySelected:(UIButton *)button;

@end
