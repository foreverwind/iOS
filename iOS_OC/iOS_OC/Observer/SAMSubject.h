//
//  SAMSubject.h
//  AddMe
//
//  Created by star on 2017/7/25.
//  Copyright © 2017年 SecretLisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAMObserver.h"

@interface NSObject (SAMSubject)

- (id)performSelector:(SEL)aSelector withArguments:(NSArray *)arguments;

@end

@interface SAMSubject : NSObject

- (void)addObserver:(id<SAMObserver>)observer;

- (void)removeObserver:(id<SAMObserver>)observer;

- (void)notify:(SEL)aSelector withArguments:(NSArray *)arguments;

@end
