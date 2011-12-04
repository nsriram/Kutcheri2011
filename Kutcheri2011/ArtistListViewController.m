#import "ArtistListViewController.h"
#import "SBJson.h"
#import "ArtistDetailViewController.h"

@interface ArtistListViewController()
@property (nonatomic, retain) NSArray *artistes;
@property (nonatomic, retain) NSString *section;
@property (nonatomic, retain)   SBJsonParser *parser;
@property (nonatomic,retain) ArtistDetailViewController *artistDetailViewController;
@end                                    

@implementation ArtistListViewController

@synthesize artistes,section,parser,artistDetailViewController;

-(NSString *)fetchArtistesData {
    NSString *artistJSON = @"";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"artist" ofType:@"json"];  
    if (filePath) {
        artistJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];  
    }
    return artistJSON;
}

- (SBJsonParser*) jsonParser {
    if(!parser){ 
        parser = [[SBJsonParser alloc] init];    
    }
    return parser;
}

-(NSArray *) parseArtistesJSON:(NSString *) artistesJSON {
    NSDictionary *jsonData = (NSDictionary*)[[self jsonParser] objectWithString:artistesJSON error:nil];    
    return [jsonData objectForKey:@"artistes"];
}

-(NSArray*) artistes {
    if(!artistes){
        NSString *artistesJSON = [self fetchArtistesData];
        self.artistes = [self parseArtistesJSON:artistesJSON];
    }
    return artistes;
}

-(NSString*) section {
    if(!section) {
        self.section = @"Artistes";
    }
    return self.section;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.artistes.count;
}

- (NSDictionary *) artistAtIndexPath:(NSIndexPath*) indexPath{
    NSDictionary *artistAtIndex = [self.artistes objectAtIndex:indexPath.row];
    return artistAtIndex;
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
    self.artistDetailViewController.artistName.text =(NSString *)[artist objectForKey:@"title"];
    self.artistDetailViewController.artistID = artistID;
}



-(void) viewDidLoad {
    [super viewDidLoad];
}

@end
