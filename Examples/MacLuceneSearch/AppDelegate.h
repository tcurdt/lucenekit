#import <Cocoa/Cocoa.h>
#import <LuceneKit/LuceneKit.h>

@interface AppDelegate : NSObject {

    IBOutlet NSTextField *searchField;
    IBOutlet NSTextField *resultField;
    
    LCIndexSearcher *searcher;
}

- (IBAction) search:(id)sender;

@end
