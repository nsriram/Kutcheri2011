#import "ArtistDetailViewController.h"
#import "SBJson.h"
#import "ScheduleCell.h"
#import "ArtistShareAppDelegate.h"
#import "SBJson.h"

@interface ArtistDetailViewController()
@property (nonatomic,retain) NSArray *schedules;
@end                                    

#define BASEURL @"http://www.ilovemadras.com/api/get_artiste_profile/?id="
#define ARTIST_DETAILS_URL @"http://www.ilovemadras.com/api/get_events_by_artiste/?id="
#define POST @"post"
#define POSTS @"posts" 
#define URL @"url"
#define EXCERPT @"excerpt"
#define ROW_HEIGHT 141.0
#define WHEN @"when"
#define WHERE @"where"
#define WHAT @"what"

@implementation ArtistDetailViewController

@synthesize artistDetail, artistID, artistProfileURL, artistName, artistDetailCache, artistScheduleTableView,schedules,indicator,uiView,artistShareAppDelegate;

-(ArtistShareAppDelegate*) artistShareAppDelegate{
    if(!artistShareAppDelegate){
        artistShareAppDelegate = [[ArtistShareAppDelegate alloc]init];
    }
    return artistShareAppDelegate;
}

-(NSString *) urlContents:(NSString *)baseURL{
    NSError *error;
    NSURL *artistDetailURL = [NSURL URLWithString:[baseURL stringByAppendingFormat:@"%@",artistID]];
    NSString *contents = [NSString stringWithContentsOfURL:artistDetailURL 
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    if(!contents && error)
    {        
        networkError = YES;        
    }
    return contents;
}

-(NSDictionary*) jsonData:(NSString*)targetURL{
    NSString *contents  = [self urlContents:targetURL];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    return(NSDictionary*)[parser objectWithString:contents error:nil];    
}

-(NSString *) artistProfile {
    NSDictionary *postData = [[self jsonData:BASEURL] objectForKey:POST];
    self.artistProfileURL = [postData objectForKey:URL];
    return  [postData objectForKey:EXCERPT];
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
    NSDictionary *jsonData = [self jsonData:ARTIST_DETAILS_URL];
    schedules = [jsonData objectForKey:POSTS];
    return schedules; 
}

- (void) loadDataWithOperation {
    [self artistDetails];
    [self fetchSchedules];    
    [self performSelectorOnMainThread:@selector(artistDetailTask) withObject:nil waitUntilDone:YES];
}

-(void) showNotification{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error loading"
                          message:@" Please check your internet connection"
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}

- (void) artistDetailTask{
    if(networkError){
        networkError = NO;
        artistID = nil;
        [indicator stopAnimating];
        self.view = self.uiView;
        [indicator removeFromSuperview];
        [self showNotification];
        return;
    }    
    
    self.artistDetail.text = [self artistDetails];
    CGRect frame = self.artistDetail.frame;
    frame.size.height = self.artistDetail.contentSize.height + 28;
    artistDetail.frame = frame;    
    [artistScheduleTableView removeFromSuperview];
    
    artistScheduleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, frame.size.height+8.0, 314.0, 372.0 - frame.size.height+8.0)];
    artistScheduleTableView.separatorColor = [UIColor whiteColor];
    artistScheduleTableView.dataSource=self;
    artistScheduleTableView.delegate=self; 
    artistScheduleTableView.allowsSelection=NO;

    [artistScheduleTableView flashScrollIndicators];     
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
        if(!indicator){
            CGRect progressFrame = CGRectMake(50, 50, 75.0, 75.0);
            indicator = [[UIActivityIndicatorView alloc] initWithFrame:progressFrame];
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        }
        self.view = indicator;
        [indicator startAnimating];
        [self loadData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self && !artistDetailCache){
        artistDetailCache = [[NSMutableDictionary alloc]init ]; 
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [artistDetailCache removeAllObjects];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setArtistScheduleTableView:nil];
    [self setIndicator:nil];
    [self setArtistShareAppDelegate:nil];
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
    return ROW_HEIGHT;
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
    cell.when.text = (NSString *)[scheduleAtIndex objectForKey:WHEN];
    cell.where.text = (NSString *)[scheduleAtIndex objectForKey:WHERE];
    cell.what.text = (NSString *)[scheduleAtIndex objectForKey:WHAT];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Performances";
}

-(IBAction)shareOnFB {
    [self.artistShareAppDelegate shareOnFB:self.artistName.text profileURL:self.artistProfileURL];
}

@end