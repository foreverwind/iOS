//
//  Subject.h
//  iOS_OC
//
//  Created by star on 2017/7/25.
//  Copyright © 2017年 foreverwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observer.h"

@interface NSObject (Subject)

- (id)performSelector:(SEL)aSelector withArguments:(NSArray *)arguments;

@end

@interface Subject : NSObject

- (void)addObserver:(id<Observer>)observer;

- (void)removeObserver:(id<Observer>)observer;

- (void)notify:(SEL)aSelector withArguments:(NSArray *)arguments;

@end
