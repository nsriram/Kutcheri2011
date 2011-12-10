#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UISegmentedControl *segmentedControl;
    UIImageView *imageView;
    UIImage *image;
    UITableView *latestEntriesTableView;
    UIActivityIndicatorView *indicator;
    NSArray *latestEventDays;
    NSMutableDictionary *latestEvents;
    NSDate *lastFetchedDate;
}
@property (nonatomic, retain) UISegmentedControl * segmentedControl;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITableView *latestEntriesTableView;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,retain) NSArray *latestEventDays;
@property (nonatomic,retain) NSMutableDictionary *latestEvents;
@property (nonatomic,retain) NSDate *lastFetchedDate;
- (IBAction)didChangeSegmentControl:(UISegmentedControl *)control;
@end
