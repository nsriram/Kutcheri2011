#import "ArtistShareAppDelegate.h"

#define HOME_URL @"http://www.ilovemadras.com/chennai-music-season/"
#define LOGO_URL @"http://ilovemadras.com/images/logo/ILMLOGOBETA.png"
#define APP_NAME @"Margazhi 2011"
#define APP_DESC @"Chennai Music Season, December 2011"
#define PHONE_APP_NAME @"Margazhi Music iPhone App"
#define PHONE_APP_URL @"http://www.ilovemadras.com/margazhi-music-app/"
#define PHONE_APP_DESC @"The Chennai Music Season or the Madras Music Season, as the season was originally called is celebrated in a period of six to seven weeks spanning the months of December and January in the English calendar, and during the Tamil month of Margazhi."
#define PIC @"picture"
#define ACTIONS @"actions"
#define PHONE_APP_CAPTION @"Your interactive music season guide"

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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
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
        artistURL = HOME_URL;
    }
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      artistName,@"name",artistURL,@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   artistName, @"name",
                                   artistName, @"caption",
                                   APP_DESC, @"description",
                                   artistURL, @"link",
                                   LOGO_URL, PIC,
                                   actionLinksStr, ACTIONS,
                                   nil];    
    [facebook dialog:@"feed" andParams:params andDelegate:self];              
}

-(void) shareAppOnFB{
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      PHONE_APP_NAME,@"name",PHONE_APP_URL,@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   PHONE_APP_NAME, @"name",
                                   PHONE_APP_CAPTION, @"caption",
                                   PHONE_APP_DESC, @"description",
                                   PHONE_APP_URL, @"link",
                                   LOGO_URL, PIC,
                                   actionLinksStr, @"actions",
                                   nil];    
    [facebook dialog:@"feed" andParams:params andDelegate:self];                  
}

@end