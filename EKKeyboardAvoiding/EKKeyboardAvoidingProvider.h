//
//  EKKeyboardAvoidingProvider.h
//  EKKeyboardAvoiding
//
//  Created by Evgeniy Kirpichenko on 9/17/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EKKeyboardFrameListener.h"

@interface EKKeyboardAvoidingProvider : NSObject{
    
    CGFloat bump;
    CGRect lastRect;
}

/*! Initializes new keyboard avoiding provider
 \param scrollView ScrollView for that keyboard avoiding will be provided
 */
- (id)initWithScrollView:(UIScrollView *)scrollView andVerticalBump:(CGFloat)verticalBump;

/// Starts keyboard avoiding
- (void)startAvoiding;

/// Stops keyboard avoiding
- (void)stopAvoiding;

/// Listens keyboard frame that will be used for extra inset calculation
@property (nonatomic, strong) EKKeyboardFrameListener *keyboardListener;

@end
