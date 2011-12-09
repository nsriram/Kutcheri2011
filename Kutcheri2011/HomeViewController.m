#import "HomeViewController.h"

@implementation HomeViewController

@synthesize segmentedControl,imageView,latestEntriesTableView,indicator;

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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self didChangeSegmentControl:self.segmentedControl];
}

- (void) loadDataWithOperation {
    [self performSelectorOnMainThread:@selector(latestEntryTask) withObject:nil waitUntilDone:YES];
}

- (void) latestEntryTask{
    self.latestEntriesTableView = [[UITableView alloc] initWithFrame:CGRectMake(14, 50.0, 314.0, 3 * 80.0)];
    self.latestEntriesTableView.delegate = self;
    self.latestEntriesTableView.dataSource = self;
    self.latestEntriesTableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:latestEntriesTableView];
    [self.latestEntriesTableView reloadData];
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
        self.latestEntriesTableView=nil;
    }
}

-(void) addImageView{
    UIImage *image = [UIImage imageNamed:@"home_icon.jpg"];
    self.imageView = [[UIImageView alloc]initWithImage:image];
    self.imageView.frame = CGRectMake(14.0, 50.0, 293.0, 259.0);    
}

-(void) removeImageView{
    if(self.imageView){
        [self.imageView removeFromSuperview];
        self.imageView=nil;
    }
}

-(void) addTableView{
    CGRect progressFrame = CGRectMake(50, 50, 75.0, 75.0);
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:progressFrame];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setHidesWhenStopped:YES];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    [self loadData];    
}

- (void)didChangeSegmentControl:(UISegmentedControl *)control {
    if(control.selectedSegmentIndex == 0){
        [self removeTableView];
        [self addImageView];
        [self.view addSubview:imageView];
    } else {
        [self removeImageView];
        [self addTableView];        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [indicator stopAnimating];
    return 3;
}          


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LatestEventTVCell";
    
    UITableViewCell *cell = [self.latestEntriesTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"some title";
    cell.detailTextLabel.text = @"some desc";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end