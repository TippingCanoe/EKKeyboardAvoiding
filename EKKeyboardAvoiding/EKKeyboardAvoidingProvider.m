//
//  EKKeyboardAvoidingProvider.m
//  EKKeyboardAvoiding
//
//  Created by Evgeniy Kirpichenko on 9/17/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import "EKKeyboardAvoidingProvider.h"
#import "EKAvoidingInsetCalculator.h"

#import "NSObject+EKKeyboardAvoiding.h"

static NSString *const kKeyboardFrameKey = @"keyboardFrame";

@interface EKKeyboardAvoidingProvider ()
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets extraContentInset;
@property (nonatomic, assign) BOOL avoidingStarted;
@end

@implementation EKKeyboardAvoidingProvider

- (id)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super init])
    {
        [self setScrollView:scrollView];
    }
    return self;
}

- (void)dealloc
{
    [self stopAvoiding];
}

#pragma mark - public methods

- (void)startAvoiding
{
    if (!self.avoidingStarted)
    {
        [self beginKeyboardFrameObserving];
        [self beginTextInputObserving];
        
        [self setAvoidingStarted:YES];
    }
}

- (void)stopAvoiding
{
    if (self.avoidingStarted)
    {
        [self resetAvoidingContentInset];
        [self endKeyboardFrameObserving];
        [self endTextInputObserving];
        
        [self setAvoidingStarted:NO];
    }
}

#pragma mark - private methods

- (void)beginKeyboardFrameObserving
{
    [[self keyboardListener] addObserver:self forKeyPath:kKeyboardFrameKey];
}

- (void)endKeyboardFrameObserving
{
    [[self keyboardListener] removeObserver:self forKeyPath:kKeyboardFrameKey];
}

- (void)beginTextInputObserving{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputViewWillBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputViewWillBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
}

- (void)endTextInputObserving{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
}

#pragma mark - update inset

- (void)addExtraContentInset:(UIEdgeInsets)extraContentInset
{
    UIEdgeInsets currentInset = [self.scrollView contentInset];
    currentInset.top += extraContentInset.top + self.scrollView.frame.origin.y;
    currentInset.bottom += extraContentInset.bottom;
    
    [self applyAvoidingContentInset:currentInset];
}

- (void)resetAvoidingContentInset
{
    UIEdgeInsets currentInset = [self.scrollView contentInset];
    currentInset.top -= self.extraContentInset.top;
    currentInset.bottom -= self.extraContentInset.bottom;
    
    [self applyAvoidingContentInset:currentInset];
}

- (void)applyAvoidingContentInset:(UIEdgeInsets)avoidingInset
{
    NSLog(@"Inset:%@", NSStringFromUIEdgeInsets(avoidingInset));
    [UIView animateWithDuration:0.2 animations:^{
        [[self scrollView] setContentInset:avoidingInset];
        [[self scrollView] setScrollIndicatorInsets:avoidingInset];
    }];
}

- (UIEdgeInsets)calculateExtraContentInset
{
    EKAvoidingInsetCalculator *calculator = [[EKAvoidingInsetCalculator alloc] init];
    
    CGRect keyboardFrame = [self.keyboardListener convertedKeyboardFrameForView:self.scrollView];
    [calculator setKeyboardFrame:keyboardFrame];
    [calculator setScrollViewFrame:[self.scrollView frame]];
    [calculator setScrollViewInset:[self.scrollView contentInset]];
    
    return [calculator calculateAvoidingInset];
}

#pragma mark - observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (keyPath == kKeyboardFrameKey)
    {
        
        if ([self.scrollView window]) {
            [self resetAvoidingContentInset];
            
            UIEdgeInsets newInset = [self calculateExtraContentInset];
            [self addExtraContentInset:newInset];
            
            [self setExtraContentInset:newInset];
        }
    }
}

#pragma mark - observe textfield/textview frame

- (void)textInputViewWillBeginEditing:(NSNotification*)notification
{
    UIView *view = notification.object;
    
    if ([view isDescendantOfView:self.scrollView]) {
        
        CGRect viewRect = [view convertRect:view.frame toView:self.scrollView];
        CGRect kbFrame = self.keyboardListener.keyboardFrame;
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGFloat accessoryViewHeight = view.inputAccessoryView ? view.inputAccessoryView.bounds.size.height : 0;
        
        CGFloat visibleVertical = screenBounds.size.height - ((screenBounds.size.height - kbFrame.origin.y) +accessoryViewHeight + 20);
        
        if (viewRect.size.height >= visibleVertical) {
            viewRect.size.height = visibleVertical;
        }
        
        //top of view is very near or above the visible area
        if ((self.scrollView.contentOffset.y + self.scrollView.contentInset.top - viewRect.origin.y) > -10) {
            viewRect.origin.y -= self.scrollView.contentInset.top;
        }
        
        [self.scrollView scrollRectToVisible:viewRect animated:YES];
    }
}

@end
