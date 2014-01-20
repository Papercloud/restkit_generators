#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
@class Post;

@interface _Comment : NSManagedObject

@property (nonatomic, retain) NSNumber *primaryKey;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *postId;


@property (nonatomic, retain) Post *post;

@end