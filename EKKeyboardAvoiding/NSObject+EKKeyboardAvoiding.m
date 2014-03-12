//
//  NSObject+EKAssociatedObject.m
//  EKKeyboardAvoiding
//
//  Created by Evgeniy Kirpichenko on 9/30/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import "NSObject+EKKeyboardAvoiding.h"

@implementation NSObject (EKKeyboardAvoiding)

#pragma mark - observe notifications

- (void)observeNotificationNamed:(NSString *)notificationName action:(SEL)action
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:action name:notificationName object:nil];
}

- (void)stopNotificationsObserving
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

#pragma mark - observe key path

- (void)addObserver:(id)target forKeyPath:(NSString *)keyPath
{
    [self addObserver:target forKeyPath:keyPath
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
}

@end
