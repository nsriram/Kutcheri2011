#import "HomeViewController.h"
#define HOMEICON @"home_icon.jpg"
@implementation HomeViewController

@synthesize segmentedControl,image,imageView,latestEntriesTableView,indicator;
static NSString *sometitle = @"some title";

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
    self.image = [UIImage imageNamed:HOMEICON];
    self.imageView = [[UIImageView alloc]initWithImage:image];
    self.imageView.frame = CGRectMake(14.0, 50.0, 293.0, 259.0);    
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

-(void) removeImageView{
    if(self.imageView){
        [self.imageView removeFromSuperview];
    }
}

-(void) addTableView{
    if(!indicator){
        CGRect progressFrame = CGRectMake(50, 50, 75.0, 75.0);
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:progressFrame];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
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
    cell.textLabel.text = sometitle;
    cell.detailTextLabel.text = sometitle;
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end