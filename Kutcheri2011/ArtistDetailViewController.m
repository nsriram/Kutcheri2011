#import "ArtistDetailViewController.h"
#import "SBJson.h"
#import "ScheduleCell.h"

@interface ArtistDetailViewController()
@property (retain) SBJsonParser *parser;
@property (nonatomic,retain) NSArray *schedules;
@end                                    

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ArtistDetailViewController

@synthesize artistDetail, artistID, parser,artistName, artistDetailCache,artistScheduleTableView,schedules;

- (SBJsonParser*) jsonParser {
    if(!parser){ 
        parser = [[SBJsonParser alloc] init];    
    }
    return parser;
}

-(NSString *) urlContents:(NSString *)baseURL{
    NSError *error;
    NSURL *artistDetailURL = [NSURL URLWithString:[baseURL stringByAppendingFormat:@"%@",artistID]];    
    return [NSString stringWithContentsOfURL:artistDetailURL 
                                    encoding:NSASCIIStringEncoding
                                       error:&error];
}

-(NSString *) artistProfile {
    NSString *baseURL = @"http://www.ilovemadras.com/api/get_artiste_profile/?id=";
    NSString *contents  = [self urlContents:baseURL];
    NSDictionary *jsonData = (NSDictionary*)[[self jsonParser] objectWithString:contents error:nil];
    NSDictionary *postData = [jsonData objectForKey:@"post"];
    return  [postData objectForKey:@"excerpt"];
}

-(NSString *) artistDetails{
    NSString *details = [artistDetailCache objectForKey:artistID];
    if(![artistDetailCache objectForKey:artistID]){
        details = [self artistProfile];
        if(!details) details = @"";
        [artistDetailCache setObject:details forKey:artistID];
    }
    return details;
}

-(NSArray*) fetchSchedules{    
    NSString *baseURL = @"http://www.ilovemadras.com/api/get_events_by_artiste/?id=";
    NSString *scheduleString  = [self urlContents:baseURL];
    NSDictionary *jsonData = (NSDictionary*)[[self jsonParser] objectWithString:scheduleString error:nil];
    schedules = [jsonData objectForKey:@"posts"];
    return schedules;
}

- (void) setArtistID:(NSString *) newArtistID {
    if(artistID != newArtistID) {
        artistID = [newArtistID copy];
        self.artistDetail.text = [self artistDetails];
        CGRect frame = self.artistDetail.frame;
        frame.size.height = self.artistDetail.contentSize.height + 28;
        self.artistDetail.frame = frame;
        
        [artistScheduleTableView removeFromSuperview];
        [self fetchSchedules];
        
        artistScheduleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, frame.size.height+12.0, self.view.frame.size.width - 6.0, schedules.count * 141.0)];
        [artistScheduleTableView setBackgroundColor:UIColorFromRGB(0xCCFFCC)];
        artistScheduleTableView.separatorColor = [UIColor whiteColor];
        [self.view addSubview:artistScheduleTableView];
        artistScheduleTableView.dataSource=self;
        artistScheduleTableView.delegate=self;
        [artistScheduleTableView reloadData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self && !artistDetailCache){
        artistDetailCache = [NSMutableDictionary dictionary]; 
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.schedules.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 141.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduleTVCell";
    ScheduleCell *cell = [artistScheduleTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"ScheduleView" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (ScheduleCell*)view;
            }
        }
    }    
    
    NSDictionary *scheduleAtIndex = [self.schedules objectAtIndex:indexPath.row];
    cell.when.text = (NSString *)[scheduleAtIndex objectForKey:@"when"];
    cell.where.text = (NSString *)[scheduleAtIndex objectForKey:@"where"];
    cell.what.text = (NSString *)[scheduleAtIndex objectForKey:@"what"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}
@end