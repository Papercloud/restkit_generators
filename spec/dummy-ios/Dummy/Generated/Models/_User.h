#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
@class Post;

@interface _User : NSManagedObject

@property (nonatomic, retain) NSNumber *primaryKey;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSArray *postIds;

@property (nonatomic, retain) NSOrderedSet *posts;

@end