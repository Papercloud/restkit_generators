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
   @"user_id" : @"userId",
   @"comment_ids" : @"commentIds",
   @"tag_ids" : @"tagIds"
  }];

  [mapping addConnectionForRelationship:@"comments" connectedBy:@{ @"commentIds" : @"primaryKey"}];
  [mapping addConnectionForRelationship:@"tags" connectedBy:@{ @"tagIds" : @"primaryKey"}];

  [mapping addConnectionForRelationship:@"user" connectedBy:@{ @"userId" : @"primaryKey"}];

  return mapping;
}

@end