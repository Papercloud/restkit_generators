#import "_User+Mapping.h"
#import "_Post+Mapping.h"

@implementation _User (Mapping)

+ (RKObjectMapping *)mapping
{
  RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
  RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"User"
                                                 inManagedObjectStore:managedObjectStore];
  mapping.identificationAttributes = @[@"primaryKey"];

  // Plain attributes
  [mapping addAttributeMappingsFromDictionary:
  @{
   @"id" : @"primaryKey",
   @"name" : @"name"
  }];

  // Has Many Posts 
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"posts"
                                                                          toKeyPath:@"posts"
                                                                        withMapping:[_Post mapping]]];
  NSRelationshipDescription *postsRelationship =
  [[mapping.entity relationshipsByName] valueForKey:@"posts"];

  RKConnectionDescription *postsConnection =
  [[RKConnectionDescription alloc] initWithRelationship:postsRelationship
                                             attributes:@{ @"posts" : @"primaryKey" }];
  [mapping addConnection:postsConnection];



  return mapping;
}

@end