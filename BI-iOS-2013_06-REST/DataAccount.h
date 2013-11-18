//
//  DataAccount.h
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 18.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DataAccount : NSManagedObject

@property (nonatomic, retain) NSNumber * accountId;
@property (nonatomic, retain) NSString * nick;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSManagedObject *feeds;

@end
