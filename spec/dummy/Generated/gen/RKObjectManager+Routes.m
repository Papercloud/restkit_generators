#import "RKObjectManager+Routes.h"

@implementation RKObjectManager (Routes)

+ (void)setupRoutes
{
[self setupPostRouteWithObjectManager:[RKObjectManager sharedManager]];
}

@end