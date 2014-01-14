#import "Generated.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface _Post : NSManagedObject

@property (nonatomic, retain) NSNumber *primaryKey;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSNumber *views;
@property (nonatomic, retain) NSNumber *userId;

@property (nonatomic, retain) NSArray *commentIds;
@property (nonatomic, retain) NSArray *tagIds;

@property (nonatomic, retain) NSOrderedSet *comments;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSOrderedSet *tags;

@end

