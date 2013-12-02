//
//  BookOperation.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 02.12.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "BookOperation.h"
#import "Contact.h"

@import AddressBook;

@implementation BookOperation
{
    BOOL _isExecuting;
    BOOL _isFinished;
}

- (NSMutableArray *)contactArray
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _contactArray = [NSMutableArray array];
    });
    return _contactArray;
}

- (void)start
{
    TRC_ENTRY;
//    [self performSelector:@selector(main) withObject:nil];
    [self main];
}

- (void)main
{
    if (self.isCancelled) {
        [self endOperation];
        return;
    }
    
    [self beginOperation];
    
    [self readContacts];
    
    [self endOperation];
}

- (void)readContacts
{
    __block ABAddressBookRef abRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (!abRef) {
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(abRef, ^(bool granted, CFErrorRef error) {
        
        if (granted) {
//            [self readContactsFromAddressBook:abRef];
        }
        

    });
    
    [self readContactsFromAddressBook:abRef];
    CFRelease(abRef);
}

- (void)readContactsFromAddressBook:(ABAddressBookRef)abRef
{
    CFArrayRef contactsRef =ABAddressBookCopyArrayOfAllPeople(abRef);
    
    for (CFIndex i = 0; i < CFArrayGetCount(contactsRef); i++) {
        
        ABRecordRef recordRef = CFArrayGetValueAtIndex(contactsRef, i);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(recordRef, kABPersonLastNameProperty);
        
        Contact *contact = [[Contact alloc] init];
        contact.firstName = firstName;
        contact.lastName = lastName;
        
        [NSThread sleepForTimeInterval:1];
        
        [self addContact:contact];
        
        
    }
    
    CFRelease(contactsRef);
}

- (void)addContact:(Contact *)contact
{
//    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:self.contactArray.count] forKey:@"contactArray"];
    
    [[self mutableArrayValueForKey:@"contactArray"] addObject:contact];
    
//    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:self.contactArray.count] forKey:@"contactArray"];
}

- (void)beginOperation
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)endOperation
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = NO;
    [self didChangeValueForKey:@"isExecuting"];

    [self willChangeValueForKey:@"isFinished"];
    _isFinished = YES;
    [self didChangeValueForKey:@"isFinished"];
    
    if (self.onFinish) {
        self.onFinish();
    }
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

@end
