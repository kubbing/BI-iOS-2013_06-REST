//
//  DataService.h
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 18.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject

+ (DataService *)sharedService;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)createAccountWithId:(NSNumber *)accountId login:(NSString *)login nick:(NSString *)nick;

- (NSArray *)accountList;

@end
