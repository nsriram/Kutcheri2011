#import "CalendarViewController.h"

@implementation CalendarViewController

-(IBAction) daySelected:(UIButton *)button{
    NSLog(@"December %@, 2011",button.titleLabel.text);
}

-(IBAction) janDaySelected:(UIButton *)button{
    NSLog(@"January %@, 2012",button.titleLabel.text);    
}

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

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
