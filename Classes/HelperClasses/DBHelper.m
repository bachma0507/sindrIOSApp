
#import "DBHelper.h"

#import "MessageTable.h"

@implementation DBHelper

@synthesize dateFormatter = _dateFormatter;

#pragma mark -
#pragma mark - Init

-(id) init {
    
    if((self = [super init]))
    {
        appDelegate=APPDELEGATE;
        [self initializeDateFormatter];
    }
    return self;
}

+ (DBHelper *)sharedObject
{
    static DBHelper *objDBHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objDBHelper = [[DBHelper alloc] init];
    });
    return objDBHelper;
}

#pragma mark -
#pragma mark - DateTime

- (void)initializeDateFormatter
{
    if (!self.dateFormatter)
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
}

- (NSDate *)dateUsingStringFromAPI:(NSString *)dateString
{
    [self initializeDateFormatter];
    // NSDateFormatter does not like ISO 8601 so strip the milliseconds and timezone
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-5)];
    
    return [self.dateFormatter dateFromString:dateString];
}

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date
{
    [self initializeDateFormatter];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    // remove Z
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-1)];
    // add milliseconds and put Z back on
    dateString = [dateString stringByAppendingFormat:@".000Z"];
    
    return dateString;
}

#pragma mark -
#pragma mark - saveContext

-(void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -
#pragma mark - Creating Object

-(id)createObjectForEntity:(NSString *)entityName
{
    if (entityName!=nil || [entityName isEqualToString:@""])
    {
        return [NSEntityDescription
                insertNewObjectForEntityForName:entityName
                inManagedObjectContext:appDelegate.managedObjectContext];
    }
    else
    {
        return nil;
    }
}


#pragma mark -
#pragma mark - get Entity

-(NSEntityDescription *)getEnitityFor:(NSString *)strEntity
{
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:strEntity inManagedObjectContext:appDelegate.managedObjectContext];
    
    return entity;
}
-(NSEntityDescription *)getEnitityFor:(NSString *)strEntity inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:strEntity
                                                                inManagedObjectContext:moc];
    
    return entity;
}

#pragma mark -
#pragma mark - Delete Object

-(void)deleteObject:(NSManagedObject *)managedObject
{
    NSManagedObjectContext *moc = appDelegate.managedObjectContext;
    [moc deleteObject:managedObject];
    [self saveContext];
}

-(NSMutableArray*) getObjectsforEntity:(NSString *)strEntity
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:strEntity inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSMutableArray *arrPatients = (NSMutableArray*)[appDelegate.managedObjectContext
                                                    executeFetchRequest:fetchRequest error:&error];
    return arrPatients;
}

-(NSMutableArray*) getObjectsforEntity:(NSString *)strEntity ShortBy:(NSString *)strShort isAscending:(BOOL)ascending
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:strEntity inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    ///////////////////////////////////////////
    [fetchRequest setIncludesPendingChanges:NO]; // DONT INCLUDE THE UNSAVED CHANGES...
    ///////////////////////////////////////////
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:strShort ascending:ascending];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error;
    NSMutableArray *arrPatients = (NSMutableArray*)[appDelegate.managedObjectContext
                                                    executeFetchRequest:fetchRequest error:&error];
    return arrPatients;
}


#pragma -
#pragma - Fetching Libs


-(NSMutableArray*) getObjectsforEntity:(NSString *)strEntity ShortBy:(NSString *)strShort isAscending:(BOOL)ascending predicate:(NSPredicate *)predicate
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:strEntity inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setIncludesPendingChanges:NO];
    
    if (strShort)
    {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:strShort
                                  ascending:ascending
                                  selector:@selector(localizedCaseInsensitiveCompare:)];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    }
    if (predicate)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSMutableArray *arrData = (NSMutableArray*)[appDelegate.managedObjectContext
                                                executeFetchRequest:fetchRequest error:&error];
    if (error != nil)
    {
        NSLog(@"Fetch Request Error :%@",error);
    }
    return arrData;
}

-(NSUInteger) getObjectCountforEntity:(NSString *)strEntity
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:strEntity inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSUInteger entityCount = [appDelegate.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    
    return entityCount;
}

-(void) deleteObjectsForEntity:(NSString *)strEntity
{
	NSManagedObjectContext *moc = appDelegate.managedObjectContext;
	
	//---------------Fetching and Deleting Category---------
	NSFetchRequest *fetchRequest;
	NSEntityDescription *entity;
	NSArray *Result;
	NSError *error;
	//---------------Fetching and Deleting ITems---------
	fetchRequest = [[NSFetchRequest alloc] init];
	entity = [NSEntityDescription entityForName:strEntity inManagedObjectContext:moc];
	[fetchRequest setEntity:entity];

	Result = [moc executeFetchRequest:fetchRequest error:nil];
    
	for (NSManagedObject *managedObject in Result) {
        [moc deleteObject:managedObject];
    }
    
	error = nil;
	[moc save:&error];
}


-(NSNumber *)getLastMsgID:(NSNumber *)senderId andRecever:(NSNumber *)receiverId
{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"((senderId == %@) AND (receiverId == %@)) OR ((senderId == %@) AND (receiverId == %@))",senderId,receiverId,receiverId,senderId];
    
    NSMutableArray *arr=[self getObjectsforEntity:ENTITY_MESSAGETABLE ShortBy:@"mid" isAscending:NO predicate:predicate];
    if (arr)
    {
        if ([arr count]!=0)
        {
            for (MessageTable *msg in arr)
            {
                if (msg.mid!=0 || msg.mid!=nil)
                {
                    return msg.mid;
                }
            }
        }
    }
    return [NSNumber numberWithInt:0];
}

-(void)insertMsgToDB:(NSMutableArray *)arrMsgs uniqueId:(NSString *)uniqueId
{
    if (arrMsgs)
    {
        if ([arrMsgs count]>0)
        {
            //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"mid == nil"];
            NSMutableArray *arr=[self getObjectsforEntity:ENTITY_MESSAGETABLE ShortBy:nil isAscending:NO predicate:nil];
            for (MessageTable *msg in arr)
            {
                NSString *strMid=msg.mid.stringValue;
                if ([strMid isEqualToString:@"0"])
                {
                    [[DBHelper sharedObject]deleteObject:msg];
                }
            }
        }
        for (NSDictionary *dict in arrMsgs)
        {
            MessageTable *messageTbl = (MessageTable *)[self createObjectForEntity:ENTITY_MESSAGETABLE];
            
            [messageTbl setFId:dict[@"sfid"]];
            [messageTbl setMessage:dict[@"msg"]];
            [messageTbl setName:dict[@"sname"]];
            [messageTbl setUniqueId:uniqueId];
            NSString  *dt = dict[@"date"];
            [messageTbl setMessageDate:dict[@"dt"]];
            [messageTbl setDate:[NSNumber numberWithDouble:dt.doubleValue]];
            [messageTbl setUniqueId:uniqueId];
            [messageTbl setReceiverId:[NSNumber numberWithLongLong:[dict[@"rfid"] longLongValue]]];
            [messageTbl setSenderId:[NSNumber numberWithLongLong:[dict[@"sfid"] longLongValue]]];
            [messageTbl setMid:[NSNumber numberWithLongLong:[dict[@"mid"] longLongValue]]];
            
            BOOL isPT=FALSE;
            NSString *strPT=dict[@"pt"];
            if (![strPT isEqualToString:@""])
            {
                isPT=TRUE;
            }
            [messageTbl setPt:[NSNumber numberWithBool:isPT]];
            
            [self saveContext];
        }
    }
}

@end