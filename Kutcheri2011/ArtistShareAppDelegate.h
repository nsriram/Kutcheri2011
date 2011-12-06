#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface ArtistShareAppDelegate : NSObject <FBSessionDelegate,FBDialogDelegate, FBRequestDelegate>{
    Facebook *facebook;
}
@property (nonatomic, retain) Facebook *facebook;
-(void) shareOnFB:(NSString*) artistName profileURL:(NSString*) artistURL;
@end
