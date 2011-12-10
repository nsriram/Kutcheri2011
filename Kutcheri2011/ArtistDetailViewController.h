#import <UIKit/UIKit.h>
#import "ArtistShareAppDelegate.h"

@interface ArtistDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITextView *artistName;
    IBOutlet UITextView *artistDetail;
    NSString *artistProfileURL;
    NSMutableDictionary *artistDetailCache;
    UITableView *artistScheduleTableView;
    NSArray *schedules;
    UIActivityIndicatorView *indicator;    
    IBOutlet UIView *uiView;
    ArtistShareAppDelegate *artistShareAppDelegate;
    BOOL networkError;
}

@property (nonatomic,retain) NSString *artistID;
@property (nonatomic,retain) UITextView *artistDetail;
@property (nonatomic,retain) UITextView *artistName;
@property (nonatomic,retain) NSString *artistProfileURL;
@property (nonatomic,retain) NSMutableDictionary *artistDetailCache;
@property (nonatomic,retain) UITableView *artistScheduleTableView;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,retain) UIView *uiView;
@property (nonatomic,retain) ArtistShareAppDelegate *artistShareAppDelegate;
-(IBAction)shareOnFB;
@end