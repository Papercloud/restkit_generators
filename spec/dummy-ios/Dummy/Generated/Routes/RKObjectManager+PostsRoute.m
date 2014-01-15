#import "RKObjectManager+PostsRoute.h"

@implementation RKObjectManager (PostsRoute)

+ (void)setupPostsRouteWithObjectManager:(RKObjectManager *)objectManager
{
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_Post mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts.json"
                                                                                   keyPath:@"posts"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_User mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts.json"
                                                                                   keyPath:@"users"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_Comment mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts.json"
                                                                                   keyPath:@"comments"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_Tag mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts.json"
                                                                                   keyPath:@"tags"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"posts"
                                                     pathPattern:@"/api/posts.json"
                                                          method:RKRequestMethodGET]];
}

@end