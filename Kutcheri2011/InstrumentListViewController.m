#import "InstrumentListViewController.h"
#import "SBJson.h"
#import "ScheduleListViewController.h"

@interface InstrumentListViewController()
@property (nonatomic, retain) NSArray *instruments;
@property (nonatomic, retain) NSString *section;
@property (nonatomic, retain) SBJsonParser *parser;
@property (nonatomic,retain) ScheduleListViewController *scheduleListViewController;
@end                                 

@implementation InstrumentListViewController

@synthesize instruments,section, parser, scheduleListViewController;

-(NSString *)fetchInstrumentsData {
    NSString *musicJSON = @"";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"instruments" ofType:@"json"];  
    if (filePath) {  
        musicJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];  
    }
    return musicJSON;
}

-(SBJsonParser *) jsonParser {
    if(!self.parser){
        self.parser = [[SBJsonParser alloc] init];
    }
    return self.parser;
}

-(NSArray *) parseInstrumentsJSON:(NSString *) instrumentsJSON {
    NSDictionary *jsonData = (NSDictionary*)[[self jsonParser] objectWithString:instrumentsJSON error:nil];
    return [[jsonData objectForKey:@"instruments"] allObjects];
}

-(NSArray*) instruments {
    if(!instruments){
        NSString *instrumentsJSON = [self fetchInstrumentsData];
        self.instruments = [self parseInstrumentsJSON:instrumentsJSON];
    }
    return instruments;
}

-(NSString*) section {
    if(!section) {
        self.section = @"Instruments";
    }
    return self.section;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.instruments.count;
}


- (NSDictionary *) instrumentAtIndexPath:(NSIndexPath*) indexPath {
    return [self.instruments objectAtIndex:indexPath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InstrumentListTableViewCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *instrument = [self instrumentAtIndexPath:indexPath];      
    cell.textLabel.text = (NSString *)[instrument objectForKey:@"title"];
    cell.detailTextLabel.text = (NSString *)[instrument objectForKey:@"description"];    
    return cell;
}

#pragma mark - Table view delegate

-(ScheduleListViewController *) scheduleListViewController {
    if(!scheduleListViewController){
        self.scheduleListViewController = 
        [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleView"];
    }
    return scheduleListViewController;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *instrument = [self instrumentAtIndexPath:indexPath];
    NSString *instrumentID = (NSString *)[instrument objectForKey:@"id"];
    [self.navigationController pushViewController:self.scheduleListViewController animated:YES];
    NSString *baseURL = @"http://www.ilovemadras.com/api/get_events_by_instrument/?count=300&id=";
    self.scheduleListViewController.schedules=nil;
    self.scheduleListViewController.eventURL = [baseURL stringByAppendingFormat:@"%@",instrumentID];
}

@end
