#import "HomeViewController.h"
#import "SBJson.h"

#define HOMEICON @"home_icon.jpg"
#define EVENTS @"events"
#define ROW_HEIGHT 62
#define DAY_IN_SECONDS 86400.0
#define FONT_NAME @"Helvetica"
#define WHERE @"where"
#define WHAT  @"what"
#define LATEST_EVENTS_URL @"http://www.ilovemadras.com/api/get_upcoming_events/"

@implementation HomeViewController

@synthesize segmentedControl,image,imageView,latestEntriesTableView,indicator,latestEvents,latestEventDays,lastFetchedDate,artistShareAppDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void) showNotification{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error loading"
                          message:@" Please check your internet connection."
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}

- (BOOL) oneDayOld{
    BOOL oneDay = FALSE;
    if(!lastFetchedDate) {
        oneDay = FALSE;
    }
    NSDate *now = [[NSDate alloc]init];
    NSTimeInterval interval = [now timeIntervalSinceDate: lastFetchedDate];
    if(interval > DAY_IN_SECONDS) {
        oneDay = TRUE;        
    }
    return oneDay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.image = [UIImage imageNamed:HOMEICON];
    self.imageView = [[UIImageView alloc]initWithImage:image];
    self.imageView.frame = CGRectMake(10.0, 50.0, 293.0, 259.0);    
    [self didChangeSegmentControl:self.segmentedControl];
}

-(NSMutableDictionary*) jsonData{
    NSError *error;
    NSURL *latestEventsURL = [NSURL URLWithString:LATEST_EVENTS_URL];
    NSString *contents  = [NSString stringWithContentsOfURL:latestEventsURL
                                                   encoding:NSASCIIStringEncoding
                                                      error:&error];
    if(!contents && error)
    {        
        networkError = YES;        
    }
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    return(NSMutableDictionary*)[parser objectWithString:contents error:nil];    
}

-(NSMutableDictionary *) latestEvents {
    if(!latestEvents || [self oneDayOld]){
        latestEvents = nil;
        latestEventDays = nil;
        latestEvents = [[self jsonData] objectForKey:EVENTS];
        lastFetchedDate = [[NSDate alloc]init];
    }
    return latestEvents;
}

-(NSArray*) latestEventDays {
    if(!latestEventDays) {
        latestEventDays = [[latestEvents allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
    return latestEventDays;
}

- (void) loadDataWithOperation {
    [self latestEvents];
    [self latestEventDays];
    [self performSelectorOnMainThread:@selector(latestEntryTask) withObject:nil waitUntilDone:YES];
}

- (void) latestEntryTask {
    self.latestEntriesTableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0, 38.0, 300.0, 280.0)];
    self.latestEntriesTableView.allowsSelection = NO;
    self.latestEntriesTableView.delegate = self;
    self.latestEntriesTableView.dataSource = self;
    self.latestEntriesTableView.separatorColor = [UIColor lightGrayColor];
    [self.latestEntriesTableView flashScrollIndicators]; 
    
    if(self.segmentedControl.selectedSegmentIndex == 1) {
        if(!networkError){
            [self.view addSubview:latestEntriesTableView];
            [self.latestEntriesTableView reloadData];
        } else {
            networkError=NO;
            [indicator stopAnimating];
            [self showNotification];
            [self setLatestEvents:nil];
        }
    } 
    
}
- (void) loadData {
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:@selector(loadDataWithOperation)
                                        object:nil];
    [queue addOperation:operation];
}

-(void) removeTableView{
    if(latestEntriesTableView){
        [self.latestEntriesTableView removeFromSuperview];
    }
}

-(void) removeImageView{
    if(self.imageView){
        [self.imageView removeFromSuperview];
    }
}

-(void) addTableView{
    if(!indicator){
        CGRect progressFrame = CGRectMake(120.0, 140.0, 75.0, 75.0);
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:progressFrame];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    [self.view addSubview:indicator];
    [indicator startAnimating];
    [self loadData];    
}

- (void)didChangeSegmentControl:(UISegmentedControl *)control {
    if(control.selectedSegmentIndex == 0){
        [self removeTableView];
        [self.view addSubview:imageView];
    } else {
        [self removeImageView];
        [self addTableView];        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return latestEventDays.count;
}


-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.latestEventDays objectAtIndex:section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [indicator stopAnimating];
    return [[latestEvents objectForKey:[self.latestEventDays objectAtIndex:section]] count];
}          

- (NSDictionary *) eventAtIndexPath:(NSIndexPath*) indexPath{
    NSDictionary *eventsInDay = [latestEvents objectForKey:[self.latestEventDays objectAtIndex:indexPath.section]];
    return eventsInDay;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LatestEventTVCell";
    
    UITableViewCell *cell = [self.latestEntriesTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
    }
    
    NSDictionary *eventsInDay = [self eventAtIndexPath:indexPath];
    NSArray *timings = [[eventsInDay allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *when = [timings objectAtIndex:indexPath.row];
    NSDictionary *whatAndWhere = [eventsInDay objectForKey:when];    
    cell.textLabel.text = [whatAndWhere objectForKey:WHAT];
    cell.detailTextLabel.text = [when stringByAppendingFormat:@", %@",[whatAndWhere objectForKey:WHERE]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.segmentedControl=nil;
    self.image = nil;
    self.imageView = nil;
    self.latestEntriesTableView=nil;
    self.indicator=nil;
    self.latestEventDays=nil;
    self.latestEvents=nil;
    self.lastFetchedDate=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(ArtistShareAppDelegate*) artistShareAppDelegate{
    if(!artistShareAppDelegate){
        artistShareAppDelegate = [[ArtistShareAppDelegate alloc]init];
    }
    return artistShareAppDelegate;
}

- (IBAction)shareOnFacebook:(UIButton *)button{
    [self.artistShareAppDelegate shareAppOnFB];
}

@end