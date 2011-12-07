#import <UIKit/UIKit.h>

@interface ArtistListViewController : UITableViewController <UITableViewDelegate> {
    NSArray *sections;
    NSMutableDictionary *artistes;
}
@end