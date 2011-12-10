#import "ScheduleListViewController.h"
#import "SBJson.h"
#import "ScheduleCell.h"

@interface ScheduleListViewController()
@property (nonatomic, retain) SBJsonParser *parser;
@end

@implementation ScheduleListViewController
@synthesize  eventURL,schedules,tableView,parser,indicator,searchedSchedules,savedSearchTerm;

- (void) loadDataWithOperation {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    [self.tableView reloadData];
}

- (void) loadData {
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:@selector(loadDataWithOperation)
                                        object:nil];
    [queue addOperation:operation];
}

- (SBJsonParser*) jsonParser {
    if(!parser){ 
        parser = [[SBJsonParser alloc] init];    
    }
    return parser;
}

-(NSArray*) schedules{    
    if(!schedules){
        NSError *error;
        NSURL *url = [NSURL URLWithString:eventURL];    
        NSString *scheduleString = [NSString stringWithContentsOfURL:url 
                                                            encoding:NSASCIIStringEncoding
                                                               error:&error];
        NSDictionary *jsonData = (NSDictionary*)[[self jsonParser] objectWithString:scheduleString error:nil];
        schedules = [jsonData objectForKey:@"posts"];
    }
    return schedules;
}

- (void) setEventURL:(NSString *) newEventURL {
    if(![eventURL isEqualToString:newEventURL]) {
        eventURL = [newEventURL copy];        
        if(!indicator){
            CGRect progressFrame = CGRectMake(50, 50, 75.0, 75.0);
            self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:progressFrame];
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [indicator setHidden:NO];
        }
        self.view = indicator;
        [indicator startAnimating];
        [self loadData];        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    eventURL=nil;
    schedules=nil;
    indicator=nil;
    tableView=nil;
    searchedSchedules=nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(void) clearSearchResults {
    if ([self searchedSchedules] == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self setSearchedSchedules:array];
    }
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    [self setSavedSearchTerm:searchTerm];
    [self clearSearchResults];
    [[self searchedSchedules] removeAllObjects];
	
    if ([[self savedSearchTerm] length] > 1)
    {
        for(NSDictionary *currentSchedule in schedules){
            NSString *when = (NSString *)[currentSchedule objectForKey:@"when"];
            NSString *what = (NSString *)[currentSchedule objectForKey:@"what"];
            NSString *where = (NSString *)[currentSchedule objectForKey:@"where"];            

            if(([when rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound) || ([where rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound) || ([what rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)){
                [searchedSchedules addObject:currentSchedule];
            }        
        }
    }
}   

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
}

- (NSInteger)tableView:(UITableView *)localTableView numberOfRowsInSection:(NSInteger)section{
    if([indicator isAnimating]){
        [indicator stopAnimating];
        self.view = localTableView;        
    }
    if (localTableView == [[self searchDisplayController] searchResultsTableView]){
        return self.searchedSchedules.count;
    }
    return self.schedules.count;
}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"LSScheduleViewCell";
    ScheduleCell *cell = [localTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"ScheduleView" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (ScheduleCell*)view;
            }
        }
    }    

    NSDictionary *scheduleAtIndex;
    if (localTableView == [[self searchDisplayController] searchResultsTableView]) {
        scheduleAtIndex = [self.searchedSchedules objectAtIndex:indexPath.row];
    }
    else {
        scheduleAtIndex = [self.schedules objectAtIndex:indexPath.row];
    }

    cell.when.text = (NSString *)[scheduleAtIndex objectForKey:@"when"];
    cell.what.text = (NSString *)[scheduleAtIndex objectForKey:@"what"];
    cell.where.text = (NSString *)[scheduleAtIndex objectForKey:@"where"];
    
    return cell;    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForTerm:searchString];    
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self setSavedSearchTerm:nil];	
    [[self tableView] reloadData];
}

@end