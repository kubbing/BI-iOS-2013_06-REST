//
//  Contact.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 02.12.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@", self.firstName, self.lastName];
}

@end
