#import <UIKit/UIKit.h>

@interface DateEventsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString *eventDate;
    NSMutableDictionary *events;
    IBOutlet UITableView *eventDateTable;
    NSMutableDictionary *dayEvents;
    NSArray *timings;
}
@property (nonatomic,retain) NSString *eventDate;
@property (nonatomic,retain) NSMutableDictionary *events;
@property (nonatomic,retain) UITableView *eventDateTable;
@property (nonatomic,retain) NSMutableDictionary *dayEvents;
@property (nonatomic,retain) NSArray *timings;
@end