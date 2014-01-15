#import <RestKit/RestKit.h>
#import "Generated.h"
#import "_Tag+Mapping.h"
#import "_Comment+Mapping.h"
#import "_User+Mapping.h"
#import "_Post+Mapping.h"

@interface RKObjectManager (PostsRoute)
+ (void)setupPostsRouteWithObjectManager:(RKObjectManager *)objectManager;
@end