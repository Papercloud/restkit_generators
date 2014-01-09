#import "RKObjectMapping+CommentSerializerMapping.h"

@implementation RKObjectMapping (CommentSerializerMapping)

+ (RKObjectMapping *)commentSerializerMapping
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
   @"post_id" : @"postId"
  }];



  return mapping;
}

@end