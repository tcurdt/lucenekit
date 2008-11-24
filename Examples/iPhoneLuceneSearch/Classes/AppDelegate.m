#import "AppDelegate.h"

static NSString *FIELD_TEXT = @"T";
static NSString *FIELD_PATH = @"P";

@implementation AppDelegate

@synthesize window;
@synthesize searchBar;
@synthesize resultField;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    [window makeKeyAndVisible];

	LCRAMDirectory *rd = [[LCRAMDirectory alloc] init];
    
    LCSimpleAnalyzer *analyzer = [[LCSimpleAnalyzer alloc] init];
    
	LCIndexWriter *writer = [[LCIndexWriter alloc] initWithDirectory: rd
															analyzer: analyzer
															  create: YES];
	LCDocument *d = [[LCDocument alloc] init];


	LCField *f1 = [[LCField alloc] initWithName: FIELD_TEXT
										string: @"This is a test text"
										 store: LCStore_YES
										 index: LCIndex_Tokenized];                                         

	LCField *f2 = [[LCField alloc] initWithName: FIELD_PATH
							   string: @"some/path/to"
								store: LCStore_YES
								index: LCIndex_NO];
	[d addField: f1];
	[d addField: f2];

	[writer addDocument: d];
	[writer close];
    
    [writer release];
    [d release];
    [f1 release];
    [f2 release];
	
	searcher = [[LCIndexSearcher alloc] initWithDirectory: rd];

    [rd release];

    [analyzer release];


}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searching %@", searchText);

    LCTerm *t = [[LCTerm alloc] initWithField: FIELD_TEXT text: searchText];

    LCTermQuery *tq = [[LCTermQuery alloc] initWithTerm: t];

    LCHits *hits = [searcher search: tq];

    LCHitIterator *iterator = [hits iterator];
    
    while([iterator hasNext]) {
        LCHit *hit = [iterator next];
        
        NSString *path = [hit stringForField: FIELD_PATH];
        NSLog(@"%@ -> %@", hit, path);
    }

    int results = [hits count];

    [resultField setText:[NSString stringWithFormat:@"%d", results]];

}

- (void)dealloc {
    [searcher release];
    [window release];
    [searchBar release];
    [super dealloc];
}


@end
