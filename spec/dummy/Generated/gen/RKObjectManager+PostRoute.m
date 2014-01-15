#import "RKObjectManager+PostRoute.h"

@implementation RKObjectManager (PostRoute)

+ (void)setupPostRouteWithObjectManager:(RKObjectManager *)objectManager
{
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Post mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:id"
                                                                                   keyPath:@"post"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[User mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:id"
                                                                                   keyPath:@"users"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Comment mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:id"
                                                                                   keyPath:@"comments"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Tag mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:id"
                                                                                   keyPath:@"tags"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"post"
                                                     pathPattern:@"/api/posts/:id"
                                                          method:RKRequestMethodGET]];
}

@end