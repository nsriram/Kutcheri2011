#import "ArtistShareAppDelegate.h"

@implementation ArtistShareAppDelegate
@synthesize facebook;

- (id)init {
    self = [super init];
    if (self) {
        facebook = [[Facebook alloc] initWithAppId:@"148691548570635" andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]){
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        if(![facebook isSessionValid]){
            [facebook authorize:nil];
        }                                                                               
    }
    return self;
}

-(void)fbDidLogout{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [facebook handleOpenURL:url];
}

-(void) fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

-(void) shareOnFB:(NSString*) artistName profileURL:(NSString*) artistURL{
    if(!artistURL){
        artistURL = @"http://www.ilovemadras.com/chennai-music-season/";
    }
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    
    // The action links to be shown with the post in the feed
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      artistName,@"name",artistURL,@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    // Dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   artistName, @"name",
                                   artistName, @"caption",
                                   @"Chennai Music Season, December 2011", @"description",
                                   artistURL, @"link",
                                   @"http://ilovemadras.com/images/logo/ILMLOGOBETA.png", @"picture",
                                   actionLinksStr, @"actions",
                                   nil];    
    [facebook dialog:@"feed" andParams:params andDelegate:self];              
}
@end