#import "AppDelegate.h"

static NSString *FIELD_TEXT = @"T";
static NSString *FIELD_PATH = @"P";

@implementation AppDelegate

- (void) fillDirectory:(LCFSDirectory*) rd
{
    LCSimpleAnalyzer *analyzer = [[LCSimpleAnalyzer alloc] init];
    
    LCIndexWriter *writer = [[LCIndexWriter alloc] initWithDirectory: rd
                                                            analyzer: analyzer
                                                              create: YES];
    
    int i = 0;
    char buffer[40000];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"]; 
    
    NSLog(@"opening %@", filePath);
    
    FILE *fh = fopen([filePath cStringUsingEncoding:NSASCIIStringEncoding], "r");
    
    if (fh) while(!feof(fh)) {
        
        if (fgets(buffer, 40000, fh) == NULL) {
            NSLog(@"no further line");
            break;
        }
        
        NSLog(@"* %d", i);
        
        NSString *line = [[NSString alloc] initWithCString:buffer];

        LCDocument *d = [[LCDocument alloc] init];


        LCField *f1 = [[LCField alloc] initWithName: FIELD_TEXT
                                            string: line
                                             store: LCStore_NO
                                             index: LCIndex_Tokenized];                                         

        LCField *f2 = [[LCField alloc] initWithName: FIELD_PATH
                                   string: [NSString stringWithFormat:@"some/path/to/%d", i]
                                    store: LCStore_YES
                                    index: LCIndex_NO];
        [d addField: f1];
        [d addField: f2];

        [f1 release];
        [f2 release];

        [writer addDocument: d];

        [d release];
        
        [line release];

        i++;
    }

    fclose(fh);

    NSLog(@"closing writer");

    [writer close];    
    [writer release];

    [analyzer release];
}

- (LCFSDirectory*) createFileDirectory
{
    // FIXME should be the application support folder
    NSString *supportPath = @".";

    NSString *path = [supportPath stringByAppendingPathComponent:@"index.idx"];

    if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
        return [[LCFSDirectory alloc] initWithPath:path create: NO];
    }

    LCFSDirectory *rd = [[LCFSDirectory alloc] initWithPath:path create: YES];

    [self fillDirectory:rd];
    
    return rd;
}

- (LCFSDirectory*) createRamDirectory
{
    LCFSDirectory *rd = [[LCRAMDirectory alloc] init];

    [self fillDirectory:rd];
    
    return rd;
}


- (void) awakeFromNib
{

    //LCFSDirectory *rd = [self createRamDirectory];
    LCFSDirectory *rd = [self createFileDirectory];

    NSLog(@"opening searcher");

	searcher = [[LCIndexSearcher alloc] initWithDirectory: rd];

    [rd release];

    NSLog(@"ready");
    
    [resultField setStringValue:@""];
}

- (IBAction) search:(id)sender
{
    [resultField setStringValue:@""];

    LCTerm *t = [[LCTerm alloc] initWithField: FIELD_TEXT text: [searchField stringValue]];

    LCTermQuery *tq = [[LCTermQuery alloc] initWithTerm: t];

    LCHits *hits = [searcher search: tq];

    LCHitIterator *iterator = [hits iterator];
    
    while([iterator hasNext]) {
        LCHit *hit = [iterator next];
        
        NSString *path = [hit stringForField: FIELD_PATH];
        NSLog(@"%@ -> %@", hit, path);
    }

    int results = [hits count];

    [resultField setStringValue: [NSString stringWithFormat:@"%d", results]];
}

- (void) dealloc
{
    [searcher release];
    
    [super dealloc];
}

@end
