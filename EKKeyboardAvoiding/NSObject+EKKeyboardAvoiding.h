//
//  NSObject+EKAssociatedObject.h
//  EKKeyboardAvoiding
//
//  Created by Evgeniy Kirpichenko on 9/30/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EKKeyboardAvoiding)

/*! Registers for notification observing
 \param notificationName The name of notification to be observed
 \param action Selector to be called when observing notification posted
 */
- (void)observeNotificationNamed:(NSString *)notificationName action:(SEL)action;

/*! Stops all notifications observing
 */
- (void)stopNotificationsObserving;

/*! Add observer for keyPath
 \param target Object to be observing keyPath values
 \param keyPath Path where observing value is placed
 */
- (void)addObserver:(id)target forKeyPath:(NSString *)keyPath;

@end
