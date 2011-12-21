#import "DateEventsViewController.h"
#import "SBJson.h"

@implementation DateEventsViewController
@synthesize eventDate, events,eventDateTable,dayEvents, timings;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void) setEventDate:(NSString *) newEventDate {
    eventDate = newEventDate;
    [eventDateTable reloadData];
}

+(NSString *)loadEventsData {
    NSString *eventDateJSON = @"";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"allevents" ofType:@"json"];  
    if (filePath) {
        eventDateJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];  
    }
    return eventDateJSON;
}

-(NSMutableDictionary *) parseArtistesJSON:(NSString *) artistesJSON {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonData = (NSDictionary*)[parser objectWithString:artistesJSON error:nil];    
    return [jsonData objectForKey:@"events"];
}

-(NSMutableDictionary*) events {
    if(!events){
        NSString *eventsJSON = [DateEventsViewController loadEventsData];
        events = [self parseArtistesJSON:eventsJSON];
    }
    return events;
}

-(NSMutableDictionary*) dayEvents {
    dayEvents = [self.events objectForKey:eventDate];
    return dayEvents;
}

-(NSArray *) timings{
    timings = [[[self.events objectForKey:eventDate] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    return timings;    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self timings] count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.timings objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dayEvents objectForKey:[self.timings objectAtIndex:section]]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DayEventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray *eventsInTime = [self.dayEvents objectForKey:[self.timings objectAtIndex:indexPath.section]];    
    NSArray *specificEvents = [eventsInTime objectAtIndex:indexPath.row];
    cell.textLabel.text = (NSString *)[specificEvents objectAtIndex:0];
    cell.detailTextLabel.text = (NSString *)[specificEvents objectAtIndex:1];        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
