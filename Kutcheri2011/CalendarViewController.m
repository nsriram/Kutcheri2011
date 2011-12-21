#import "CalendarViewController.h"

@implementation CalendarViewController
@synthesize dateEventsViewController;

-(DateEventsViewController *) dateEventsViewController {
    if(!dateEventsViewController){
        self.dateEventsViewController = 
        [self.storyboard instantiateViewControllerWithIdentifier:@"DateEventsView"];
    }
    return dateEventsViewController;
}

-(IBAction) daySelected:(UIButton *)button{
    NSString *eventDate = @"December";
    eventDate = [eventDate stringByAppendingFormat:@" %@, 2011",button.titleLabel.text];
    [self.navigationController pushViewController:self.dateEventsViewController animated:YES];
    [self.dateEventsViewController setEventDate:eventDate];
}

-(IBAction) janDaySelected:(UIButton *)button{
    NSString *eventDate = @"January";
    eventDate = [eventDate stringByAppendingFormat:@" %@, 2012",button.titleLabel.text];
    [self.navigationController pushViewController:self.dateEventsViewController animated:YES];
    [self.dateEventsViewController setEventDate:eventDate];
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
