#import "SabhaListViewController.h"
#import "SBJson.h"
#import "ScheduleListViewController.h"

@interface SabhaListViewController()
@property (nonatomic,retain) NSArray *sabhas;
@property (nonatomic,retain) NSString *section;
@property (nonatomic, retain) SBJsonParser *parser;
@property (nonatomic,retain) ScheduleListViewController *scheduleListViewController;
@end

@implementation SabhaListViewController

@synthesize sabhas, section, parser,scheduleListViewController;

-(NSString *)fetchSabhasData {
    NSString *sabhaJSON = @"";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sabha" ofType:@"json"];  
    if (filePath) {  
        sabhaJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];  
    }
    return sabhaJSON;
}

-(SBJsonParser *) jsonParser {
    if(!self.parser){
        self.parser = [[SBJsonParser alloc] init];
    }
    return self.parser;
}

-(NSArray *) parseSabhasJSON:(NSString *) sabhasJSON {
    NSDictionary *jsonData = (NSDictionary*)[[self jsonParser] objectWithString:sabhasJSON error:nil];
    return [jsonData objectForKey:@"sabhas"];
}

-(NSArray*) sabhas {
    if(!sabhas){
        NSString *sabhasJSON = [self fetchSabhasData];
        self.sabhas = [self parseSabhasJSON:sabhasJSON];
    }
    return sabhas;
}

-(NSString*) section {
    if(!section) {
        self.section = @"Sabhas";
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sabhas.count;
}

- (NSDictionary *) sabhaAtIndexPath:(NSIndexPath*) indexPath{
    return [self.sabhas objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SabhaListTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *sabha = [self sabhaAtIndexPath:indexPath];      
    cell.textLabel.text = (NSString *)[sabha objectForKey:@"title"];
    cell.detailTextLabel.text = (NSString *)[sabha objectForKey:@"description"];
    
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
    NSDictionary *sabha = [self sabhaAtIndexPath:indexPath];
    NSString *sabhaID = (NSString *)[sabha objectForKey:@"id"];
    [self.navigationController pushViewController:self.scheduleListViewController animated:YES];
    NSString *baseURL = @"http://www.ilovemadras.com/api/get_events_by_sabha/?count=300&id=";
    self.scheduleListViewController.schedules=nil;
    self.scheduleListViewController.eventURL = [baseURL stringByAppendingFormat:@"%@",sabhaID];
}

@end
