#import "Generated.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface _Tag : NSManagedObject

@property (nonatomic, retain) NSNumber *primaryKey;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSOrderedSet *posts;

@end

// Stub out 'Tag' as scaffolding and for testing.
// This will be removed if you add a Tag.h file within 
// your project directory and re-run the generator.
@interface Tag : _Tag @end
@implementation Tag @end
