//
//  SAMSubject.m
//  AddMe
//
//  Created by star on 2017/7/25.
//  Copyright © 2017年 SecretLisa. All rights reserved.
//

#import "SAMSubject.h"

@implementation NSObject (SAMSubject)

- (id)performSelector:(SEL)aSelector withArguments:(NSArray *)arguments
{
    if (aSelector == nil) {
        return nil;
    }
    
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    if (signature == nil) {
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    if (invocation == nil) {
        return nil;
    }
    
    invocation.target = self;
    invocation.selector = aSelector;
    
    // invocation 有2个隐藏参数，所以 argument 从2开始
    if ([arguments isKindOfClass:[NSArray class]]) {
        NSInteger count = MIN(arguments.count, signature.numberOfArguments - 2);
        for (int i = 0; i < count; i++) {
            const char *type = [signature getArgumentTypeAtIndex:2 + i];
            
            // 需要做参数类型判断然后解析成对应类型，这里默认所有参数均为OC对象
            id argument = arguments[i];
            if (strcmp(type, @encode(id)) == 0) {
                [invocation setArgument:&argument atIndex:2 + i];
            } else if (strcmp(type, @encode(short)) == 0) {
                short arg = [argument intValue];
                [invocation setArgument:&arg atIndex:2 + i];
            } else if (strcmp(type, @encode(int)) == 0) {
                int arg = [argument intValue];
                [invocation setArgument:&arg atIndex:2 + i];
            } else if (strcmp(type, @encode(long)) == 0) {
                long arg = [argument intValue];
                [invocation setArgument:&arg atIndex:2 + i];
            } else if (strcmp(type, @encode(long long)) == 0) {
                long long arg = [argument intValue];
                [invocation setArgument:&arg atIndex:2 + i];
            } else if (strcmp(type, @encode(float)) == 0) {
                float arg = [argument floatValue];
                [invocation setArgument:&arg atIndex:2 + i];
            } else if (strcmp(type, @encode(double)) == 0) {
                double arg = [argument doubleValue];
                [invocation setArgument:&arg atIndex:2 + i];
            } else if (strcmp(type, @encode(BOOL)) == 0) {
                BOOL arg = [argument boolValue];
                [invocation setArgument:&arg atIndex:2 + i];
            }
        }
    }
    
    [invocation invoke];
    
    id returnVal;
    if (strcmp(signature.methodReturnType, @encode(id)) == 0) {
        [invocation getReturnValue:&returnVal];
    }
    // 需要做返回类型判断。比如返回值为常量需要包装成对象，这里仅以最简单的`@`为例
    return returnVal;
}

@end

@interface SAMSubject ()

@property (nonatomic, strong) NSHashTable *observers;

@end

@implementation SAMSubject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.observers = [NSHashTable weakObjectsHashTable];
    }
    
    return self;
}

- (void)addObserver:(id<SAMObserver>)observer
{
    @synchronized (self) {
        [self.observers addObject:observer];
    }
}

- (void)removeObserver:(id<SAMObserver>)observer
{
    @synchronized (self) {
        if ([self.observers containsObject:observer]) {
            [self.observers removeObject:observer];
        }
    }
}

- (void)notify:(SEL)aSelector withArguments:(NSArray *)arguments
{
    @synchronized (self) {
        for (id observer in self.observers) {
            if ([observer respondsToSelector:aSelector]) {
                [observer performSelector:aSelector withArguments:arguments];
            }
        }
    }
}

@end
