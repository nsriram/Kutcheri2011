#import "ArtistDetailViewController.h"
#import "SBJson.h"
#import "ScheduleCell.h"
#import "ArtistShareAppDelegate.h"
#import "SBJson.h"

@interface ArtistDetailViewController()
@property (retain) SBJsonParser *parser;
@property (nonatomic,retain) NSArray *schedules;
@end                                    

@implementation ArtistDetailViewController

@synthesize artistDetail, artistID, artistProfileURL, artistName, artistDetailCache, parser, artistScheduleTableView,schedules,indicator,uiView,artistShareAppDelegate;

-(ArtistShareAppDelegate*) artistShareAppDelegate{
    if(!artistShareAppDelegate){
        artistShareAppDelegate = [[ArtistShareAppDelegate alloc]init];
    }
    return artistShareAppDelegate;
}

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
    self.artistProfileURL = [postData objectForKey:@"url"];
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

- (void) loadDataWithOperation {
    [self artistDetails];
    [self fetchSchedules];    
    [self performSelectorOnMainThread:@selector(artistDetailTask) withObject:nil waitUntilDone:YES];
}

- (void) artistDetailTask{
    self.artistDetail.text = [self artistDetails];
    CGRect frame = self.artistDetail.frame;
    frame.size.height = self.artistDetail.contentSize.height + 28;
    artistDetail.frame = frame;    
    
    [artistScheduleTableView removeFromSuperview];
    
    artistScheduleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, frame.size.height+8.0, 314.0, schedules.count * 141.0)];
    artistScheduleTableView.separatorColor = [UIColor whiteColor];
    artistScheduleTableView.dataSource=self;
    artistScheduleTableView.delegate=self;
    [artistScheduleTableView reloadData];
    [indicator stopAnimating];
    self.view = self.uiView;
    [indicator removeFromSuperview];
    [self.view addSubview:artistScheduleTableView];
}

- (void) loadData {
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:@selector(loadDataWithOperation)
                                        object:nil];
    [queue addOperation:operation];
}


- (void) setArtistID:(NSString *) newArtistID {
    if(artistID != newArtistID) {
        artistID = [newArtistID copy];
        CGRect progressFrame = CGRectMake(50, 50, 75.0, 75.0);
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:progressFrame];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator setHidesWhenStopped:YES];
        self.view = indicator;
        [indicator startAnimating];
        [self loadData];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(IBAction)shareOnFB {
    [self.artistShareAppDelegate shareOnFB:self.artistName.text profileURL:self.artistProfileURL];
}

@end