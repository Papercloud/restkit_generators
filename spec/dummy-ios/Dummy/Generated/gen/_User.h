#import "Generated.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface _User : NSManagedObject

@property (nonatomic, retain) NSNumber *primaryKey;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSOrderedSet *posts;

@end

// Stub out 'User' as scaffolding and for testing.
// This will be removed if you add a User.h file within 
// your project directory and re-run the generator.
@interface User : _User @end
@implementation User @end
