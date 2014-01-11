#import "_Post+Mapping.h"
#import "_Comment+Mapping.h"
#import "_User+Mapping.h"
#import "_Tag+Mapping.h"

@implementation _Post (Mapping)

+ (RKObjectMapping *)mapping
{
  RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
  RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Post"
                                                 inManagedObjectStore:managedObjectStore];
  mapping.identificationAttributes = @[@"primaryKey"];

  // Plain attributes
  [mapping addAttributeMappingsFromDictionary:
  @{
   @"id" : @"primaryKey",
   @"name" : @"name",
   @"date" : @"date",
   @"views" : @"views",
   @"user_id" : @"userId"
  }];

  // Has Many Comments 
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comments"
                                                                          toKeyPath:@"comments"
                                                                        withMapping:[_Comment mapping]]];
  NSRelationshipDescription *commentsRelationship =
  [[mapping.entity relationshipsByName] valueForKey:@"comments"];

  RKConnectionDescription *commentsConnection =
  [[RKConnectionDescription alloc] initWithRelationship:commentsRelationship
                                             attributes:@{ @"comments" : @"primaryKey" }];
  [mapping addConnection:commentsConnection];

  // Has Many Tags 
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"tags"
                                                                          toKeyPath:@"tags"
                                                                        withMapping:[_Tag mapping]]];
  NSRelationshipDescription *tagsRelationship =
  [[mapping.entity relationshipsByName] valueForKey:@"tags"];

  RKConnectionDescription *tagsConnection =
  [[RKConnectionDescription alloc] initWithRelationship:tagsRelationship
                                             attributes:@{ @"tags" : @"primaryKey" }];
  [mapping addConnection:tagsConnection];


  // Has One User
  NSRelationshipDescription *userRelationship =
  [[mapping.entity relationshipsByName] valueForKey:@"user"];
  
  RKConnectionDescription *userConnection =
  [[RKConnectionDescription alloc] initWithRelationship:userRelationship
                                             attributes:@{ @"user_id" : @"primaryKey" }];
  [mapping addConnection:userConnection];

  return mapping;
}

@end