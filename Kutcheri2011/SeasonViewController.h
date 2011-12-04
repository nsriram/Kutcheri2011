#import <UIKit/UIKit.h>

@interface SeasonViewController : UIViewController <UIWebViewDelegate>{
    UIWebView *webView;
    UIActivityIndicatorView *indicator;
}
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@end
