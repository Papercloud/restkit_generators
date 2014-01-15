#import "_Comment+Mapping.h"
#import "_Post+Mapping.h"

@implementation _Comment (Mapping)

+ (RKObjectMapping *)mapping
{
  RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
  RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Comment"
                                                 inManagedObjectStore:managedObjectStore];
  mapping.identificationAttributes = @[@"primaryKey"];

  // Plain attributes
  [mapping addAttributeMappingsFromDictionary:
  @{
   @"id" : @"primaryKey",
   @"body" : @"body",
   @"title" : @"title",
   @"post_id" : @"postId"
  }];


  [mapping addConnectionForRelationship:@"post" connectedBy:@{ @"postId" : @"primaryKey"}];

  return mapping;
}

@end