#import <UIKit/UIKit.h>

@interface ArtistListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate> {
    IBOutlet UITableView *artistListTable;
    NSArray *sections;
    NSMutableDictionary *artistes;
    NSString *savedSearchTerm;
    NSMutableArray *searchedSections;
    NSMutableDictionary *searchedArtistes;
}
@property (nonatomic, retain) IBOutlet UITableView *artistListTable;
@property (nonatomic, retain) NSMutableArray *searchedSections;
@property (nonatomic, retain) NSMutableDictionary *searchedArtistes;
@property (nonatomic, copy) NSString *savedSearchTerm;
- (void)handleSearchForTerm:(NSString *)searchTerm;
@end