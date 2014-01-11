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


  // Has One Post
  NSRelationshipDescription *postRelationship =
  [[mapping.entity relationshipsByName] valueForKey:@"post"];
  
  RKConnectionDescription *postConnection =
  [[RKConnectionDescription alloc] initWithRelationship:postRelationship
                                             attributes:@{ @"post_id" : @"primaryKey" }];
  [mapping addConnection:postConnection];

  return mapping;
}

@end