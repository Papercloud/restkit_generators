#import "RKObjectManager+PostUserRoute.h"

@implementation RKObjectManager (PostUserRoute)

+ (void)setupPostUserRouteWithObjectManager:(RKObjectManager *)objectManager
{
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_User mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:post_id/user.json"
                                                                                   keyPath:@"user"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"post_user"
                                                     pathPattern:@"/api/posts/:post_id/user.json"
                                                          method:RKRequestMethodGET]];
}

@end