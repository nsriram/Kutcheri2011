#import <UIKit/UIKit.h>

@interface ScheduleListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>{
    IBOutlet UITableView *tableView;
    NSArray *schedules;
    UIActivityIndicatorView *indicator;
    NSString *eventURL;
    NSMutableArray *searchedSchedules;
    NSString *savedSearchTerm;
}
@property (nonatomic,retain) NSString *eventURL;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSArray *schedules;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,retain) NSMutableArray *searchedSchedules;
@property (nonatomic, copy) NSString *savedSearchTerm;
- (void)handleSearchForTerm:(NSString *)searchTerm;
@end