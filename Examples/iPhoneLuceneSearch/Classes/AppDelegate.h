#import <UIKit/UIKit.h>
#import "LuceneKit.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, UISearchBarDelegate> {

    UIWindow *window;
    UISearchBar *searchBar;
    UILabel *resultField;

    LCIndexSearcher *searcher;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UILabel *resultField;

@end

