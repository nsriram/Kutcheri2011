#import "ArtistListViewController.h"
#import "SBJson.h"
#import "ArtistDetailViewController.h"

@interface ArtistListViewController()
@property (nonatomic, retain) NSMutableDictionary *artistes;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic,retain) ArtistDetailViewController *artistDetailViewController;
@end                                    

@implementation ArtistListViewController

@synthesize artistListTable,artistes,sections,artistDetailViewController, searchedArtistes, searchedSections,savedSearchTerm;

-(NSString *)fetchArtistesData {
    NSString *artistJSON = @"";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"artist" ofType:@"json"];  
    if (filePath) {
        artistJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];  
    }
    return artistJSON;
}

-(NSMutableDictionary *) parseArtistesJSON:(NSString *) artistesJSON {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonData = (NSDictionary*)[parser objectWithString:artistesJSON error:nil];    
    return [jsonData objectForKey:@"artistes"];
}

-(NSMutableDictionary*) artistes {
    if(!artistes){
        NSString *artistesJSON = [self fetchArtistesData];
        artistes = [self parseArtistesJSON:artistesJSON];
    }
    return artistes;
}

-(NSArray*) sections {
    if(!sections) {
        sections = [[self.artistes allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
    return sections;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void) viewDidLoad {
    [super viewDidLoad];
    [self artistes];
    [self sections];
    if ([self savedSearchTerm])
    {
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }  
    self.artistListTable.scrollEnabled = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
    [self setSearchedArtistes:nil];
    [self setSearchedSections:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self artistListTable] reloadData];
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
    if ([self searchedArtistes] == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self setSearchedSections:array];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [self setSearchedArtistes:dict];
    }
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    [self setSavedSearchTerm:searchTerm];
    [self clearSearchResults];
    [[self searchedSections] removeAllObjects];
    [[self searchedArtistes] removeAllObjects];
	
    if ([[self savedSearchTerm] length] > 1)
    {
        for(NSString *currentSection in [artistes allKeys]){
            NSArray *artistesInSection = [artistes objectForKey:currentSection];
            NSMutableArray *searchedTempArray = [[NSMutableArray alloc] init];
            for (NSMutableDictionary *currentArtist in artistesInSection) {
                NSString* currentArtistName = (NSString *)[currentArtist objectForKey:@"title"];
                if ([currentArtistName rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound){
                    [searchedTempArray addObject:currentArtist];
                }
            }
            if([searchedTempArray count] != 0) {
                [[self searchedArtistes] setObject:searchedTempArray forKey:currentSection];
            }
        }
        if([[self searchedArtistes] count] != 0) {
            searchedSections = [NSMutableArray arrayWithArray:[[[self searchedArtistes] allKeys] sortedArrayUsingSelector:@selector(compare:)]];
        }
    }
}                                                 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections;
    if (tableView == [[self searchDisplayController] searchResultsTableView])
        numberOfSections = [[self searchedSections] count];
    else
        numberOfSections = [[self sections] count];
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    NSArray *artistesInSection;
    if (tableView == [[self searchDisplayController] searchResultsTableView]) {
        artistesInSection = [self.searchedArtistes objectForKey:[self.searchedSections objectAtIndex:section]];
    }
    else{
        artistesInSection = [self.artistes objectForKey:[self.sections objectAtIndex:section]];
    }
    rows = artistesInSection.count;
    return rows;
}

- (NSDictionary *) artistAtIndexPath:(NSIndexPath*) indexPath{
    NSArray *artistesInSection = [self.artistes objectForKey:[self.sections objectAtIndex:indexPath.section]];    
    return [artistesInSection objectAtIndex:indexPath.row];
}

- (NSDictionary *) artistAtSearchIndexPath:(NSIndexPath*) indexPath{
    NSArray *artistesInSection = [self.searchedArtistes objectForKey:[self.searchedSections objectAtIndex:indexPath.section]];    
    return [artistesInSection objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArtistListTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *artist;      
    if (tableView == [[self searchDisplayController] searchResultsTableView]) {
        artist = [self artistAtSearchIndexPath:indexPath];
    }
    else {
        artist = [self artistAtIndexPath:indexPath];
    }
    
    cell.textLabel.text = (NSString *)[artist objectForKey:@"title"];
    cell.detailTextLabel.text = (NSString *)[artist objectForKey:@"description"];        
    
    return cell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *someSection;
    if (tableView == [[self searchDisplayController] searchResultsTableView]) {
        someSection = [self.searchedSections objectAtIndex:section];
    }
    else {
        someSection =[self.sections objectAtIndex:section];
    }
    return someSection;
}

-(ArtistDetailViewController *) artistDetailViewController {
    if(!artistDetailViewController){
        self.artistDetailViewController = 
        [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistDetailView"];
        self.artistDetailViewController.artistDetailCache = [[NSMutableDictionary alloc] init];
    }
    return artistDetailViewController;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *artist;      
    if (tableView == [[self searchDisplayController] searchResultsTableView]) {
        artist = [self artistAtSearchIndexPath:indexPath];
    }
    else {
        artist = [self artistAtIndexPath:indexPath];
    }
    NSString *artistID = (NSString *)[artist objectForKey:@"id"];
    [self.navigationController pushViewController:self.artistDetailViewController animated:YES];
    self.artistDetailViewController.artistID = artistID;
    self.artistDetailViewController.artistName.text =(NSString *)[artist objectForKey:@"title"];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForTerm:searchString];    
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self setSavedSearchTerm:nil];	
    [[self artistListTable] reloadData];
}

@end
