#import "SeasonViewController.h"

@implementation SeasonViewController

@synthesize webView, indicator;

-(void)webViewDidStartLoad:(UIWebView *)webView{

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicator stopAnimating];
    self.view = self.webView;
}

-(NSURLRequest *) urlRequest{
    NSString *urlString = @"http://www.ilovemadras.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return request;
}

-(void) loadView {
    CGRect progressFrame = CGRectMake(50, 50, 75.0, 75.0);
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:progressFrame];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    self.view = indicator;
    [indicator startAnimating];
    
    webView = [[UIWebView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    webView.delegate = self;
    [webView loadRequest:[self urlRequest]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [webView loadRequest:[self urlRequest]];
}

-(void)viewDidLayoutSubviews{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
