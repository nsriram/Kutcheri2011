#import "ScheduleListViewController.h"
#import "SBJson.h"
#import "ScheduleCell.h"

@interface ScheduleListViewController()
@property (nonatomic, retain) SBJsonParser *parser;
@end

@implementation ScheduleListViewController
@synthesize  eventURL,schedules,tableView,parser,indicator;

- (void) loadDataWithOperation {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor blackColor];
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
        NSLog(@"invoking URL");
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
    if(eventURL != newEventURL) {
        eventURL = [newEventURL copy];
        CGRect progressFrame = CGRectMake(50, 50, 75.0, 75.0);
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:progressFrame];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator setHidesWhenStopped:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [indicator stopAnimating];
    self.view = self.tableView;
    return self.schedules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"LSScheduleViewCell";
    ScheduleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

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
    cell.what.text = (NSString *)[scheduleAtIndex objectForKey:@"what"];
    cell.where.text = (NSString *)[scheduleAtIndex objectForKey:@"where"];
    
    return cell;    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}

@end