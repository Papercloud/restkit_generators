#import "RKObjectManager+PostRoute.h"

@implementation RKObjectManager (PostRoute)

+ (void)setupPostRouteWithObjectManager:(RKObjectManager *)objectManager
{
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_Post mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:id.json"
                                                                                   keyPath:@"post"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_User mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:id.json"
                                                                                   keyPath:@"users"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_Comment mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:id.json"
                                                                                   keyPath:@"comments"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_Tag mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:id.json"
                                                                                   keyPath:@"tags"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"post"
                                                     pathPattern:@"/api/posts/:id.json"
                                                          method:RKRequestMethodGET]];
}

@end