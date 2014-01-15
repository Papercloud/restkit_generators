#import "RKObjectManager+PostCommentsRoute.h"

@implementation RKObjectManager (PostCommentsRoute)

+ (void)setupPostCommentsRouteWithObjectManager:(RKObjectManager *)objectManager
{
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_Comment mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:post_id/comments.json"
                                                                                   keyPath:@"comments"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"post_comments"
                                                     pathPattern:@"/api/posts/:post_id/comments.json"
                                                          method:RKRequestMethodGET]];
}

@end