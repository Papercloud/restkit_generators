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
   @"name" : @"name",
   @"post_ids" : @"postIds"
  }];

  [mapping addConnectionForRelationship:@"posts" connectedBy:@{ @"postIds" : @"primaryKey"}];


  return mapping;
}

@end