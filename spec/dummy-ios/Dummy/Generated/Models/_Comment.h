#import "Generated.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface _Comment : NSManagedObject

@property (nonatomic, retain) NSNumber *primaryKey;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *postId;


@property (nonatomic, retain) Post *post;

@end

// Stub out 'Comment' as scaffolding and for testing.
// This will be removed if you add a Comment.h file within 
// your project directory and re-run the generator.
@interface Comment : _Comment @end
