#import "RKObjectManager+Routes.h"

@implementation RKObjectManager (Routes)

+ (void)setupRoutes
{
  [self setupPostUserRouteWithObjectManager:[RKObjectManager sharedManager]];
  [self setupPostCommentsRouteWithObjectManager:[RKObjectManager sharedManager]];
  [self setupPostTagsRouteWithObjectManager:[RKObjectManager sharedManager]];
  [self setupPostsRouteWithObjectManager:[RKObjectManager sharedManager]];
  [self setupPostRouteWithObjectManager:[RKObjectManager sharedManager]];
}

@end