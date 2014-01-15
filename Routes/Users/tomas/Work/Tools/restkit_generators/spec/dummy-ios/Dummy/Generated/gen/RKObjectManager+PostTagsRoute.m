#import "RKObjectManager+PostTagsRoute.h"

@implementation RKObjectManager (PostTagsRoute)

+ (void)setupPostTagsRouteWithObjectManager:(RKObjectManager *)objectManager
{
  [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[_Tag mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/api/posts/:post_id/tags.json"
                                                                                   keyPath:@"tags"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
  
  [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"post_tags"
                                                     pathPattern:@"/api/posts/:post_id/tags.json"
                                                          method:RKRequestMethodGET]];
}

@end