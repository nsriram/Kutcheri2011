#import <UIKit/UIKit.h>

@interface ArtistDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITextView *artistName;
    IBOutlet UITextView *artistDetail;
    NSMutableDictionary *artistDetailCache;
    UITableView *artistScheduleTableView;
    NSArray *schedules;
}

@property (nonatomic,retain) UITextView *artistDetail;
@property (nonatomic,retain) UITextView *artistName;
@property (nonatomic,retain) NSString *artistID;
@property (nonatomic,retain) NSMutableDictionary *artistDetailCache;
@property (nonatomic,retain) UITableView *artistScheduleTableView;
@end
