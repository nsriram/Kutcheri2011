#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UISegmentedControl *segmentedControl;
    UIImageView *imageView;
    UIImage *image;
    UITableView *latestEntriesTableView;
    UIActivityIndicatorView *indicator;
}
@property (nonatomic, retain) UISegmentedControl * segmentedControl;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITableView *latestEntriesTableView;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
- (IBAction)didChangeSegmentControl:(UISegmentedControl *)control;
@end
