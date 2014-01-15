#import <RestKit/RestKit.h>
#import "Generated.h"
#import "_Tag+Mapping.h"
#import "_Comment+Mapping.h"
#import "_User+Mapping.h"
#import "_Post+Mapping.h"

@interface RKObjectManager (PostRoute)
+ (void)setupPostRouteWithObjectManager:(RKObjectManager *)objectManager;
@end