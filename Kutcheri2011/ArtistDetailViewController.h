#import <UIKit/UIKit.h>

@interface ArtistDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITextView *artistName;
    IBOutlet UITextView *artistDetail;
    NSMutableDictionary *artistDetailCache;
    UITableView *artistScheduleTableView;
    NSArray *schedules;
    UIActivityIndicatorView *indicator;    
    IBOutlet UIView *uiView;
}

@property (nonatomic,retain) NSString *artistID;
@property (nonatomic,retain) UITextView *artistDetail;
@property (nonatomic,retain) UITextView *artistName;
@property (nonatomic,retain) NSMutableDictionary *artistDetailCache;
@property (nonatomic,retain) UITableView *artistScheduleTableView;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,retain) UIView *uiView;
@end
