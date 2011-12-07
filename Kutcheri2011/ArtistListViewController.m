#import "ArtistListViewController.h"
#import "SBJson.h"
#import "ArtistDetailViewController.h"

@interface ArtistListViewController()
@property (nonatomic, retain) NSMutableDictionary *artistes;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic,retain) ArtistDetailViewController *artistDetailViewController;
@end                                    

@implementation ArtistListViewController

@synthesize artistes,sections,artistDetailViewController;

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
        NSLog(@"%d",artistes.count);
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
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *artistesInSection = [self.artistes objectForKey:[self.sections objectAtIndex:section]];
    return artistesInSection.count;                                                              
}

- (NSDictionary *) artistAtIndexPath:(NSIndexPath*) indexPath{
    NSArray *artistesInSection = [self.artistes objectForKey:[self.sections objectAtIndex:indexPath.section]];    
    return [artistesInSection objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArtistListTableViewCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *artist = [self artistAtIndexPath:indexPath];      
    cell.textLabel.text = (NSString *)[artist objectForKey:@"title"];
    cell.detailTextLabel.text = (NSString *)[artist objectForKey:@"description"];        
    
    return cell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sections objectAtIndex:section];
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
    NSDictionary *artist = [self artistAtIndexPath:indexPath];
    NSString *artistID = (NSString *)[artist objectForKey:@"id"];
    [self.navigationController pushViewController:self.artistDetailViewController animated:YES];
    self.artistDetailViewController.artistID = artistID;
    self.artistDetailViewController.artistName.text =(NSString *)[artist objectForKey:@"title"];
}



-(void) viewDidLoad {
    [super viewDidLoad];
}

@end
