//
//  DataAccount+ext.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 18.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "DataAccount+ext.h"

@implementation DataAccount (ext)

- (NSString *)description
{
    return [NSString stringWithFormat:@"acc: %@, %@, %@", self.accountId, self.login, self.nick];
}

@end
