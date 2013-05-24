//
//  VKRSChameleonSwitch.m
//  Weight Me
//
//  Created by Vilem Kurz on 24/05/2013.
//  Copyright (c) 2013 Cocoa Miners.

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "VKRSChameleonSwitch.h"
#import <QuartzCore/QuartzCore.h>

#define TAP_SENSITIVITY 10 //margin of error to detect if the switch was tapped or swiped.
#define ANIMATION_DURATION 0.23

@interface VKRSChameleonSwitch ()

@property (strong, nonatomic) UIImage *buttonImage;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIImage *borderImage;

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *buttonImageView;
@property (strong, nonatomic) UIImageView *borderImageView;

@property (nonatomic) CGPoint firstTouchPoint;
@property (nonatomic) CGFloat touchDistanceFromButton;

@end

@implementation VKRSChameleonSwitch

- (id)initWithOrigin:(CGPoint)origin
     backgroundImage:(UIImage *)bgImage
         buttonImage:(UIImage *)buttonImage
         borderImage:(UIImage *)borderImage {
    
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, borderImage.size.width, borderImage.size.height)];
    
    if (self) {
        
        _backgroundImage = bgImage;
        _buttonImage = buttonImage;
        _borderImage = borderImage;
        
        _backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
        [self addSubview:_backgroundImageView];
        
        _borderImageView = [[UIImageView alloc] initWithImage:self.borderImage];
        [self addSubview:_borderImageView];
        
        _buttonImageView = [[UIImageView alloc] initWithImage:self.buttonImage];
        [self addSubview:_buttonImageView];
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)setLeftView:(UIView *)leftView {
    
    _leftView = leftView;
    
    CGRect frame = CGRectMake(0, 0, [self labelWidth], [self height]);
    leftView.frame = UIEdgeInsetsInsetRect(frame, self.leftViewInsets);
    [self.backgroundImageView addSubview:leftView];
}

- (void)setLeftViewInsets:(UIEdgeInsets)leftViewInsets {
    
    _leftViewInsets = leftViewInsets;
    
    self.leftView.frame = UIEdgeInsetsInsetRect(self.leftView.frame, leftViewInsets);
}

- (void)setRightView:(UIView *)rightView {
    
    _rightView = rightView;
    
    CGRect frame = CGRectMake(self.backgroundImageView.frame.size.width - [self labelWidth], 0, [self labelWidth], [self height]);
    rightView.frame = UIEdgeInsetsInsetRect(frame, self.rightViewInsets);
    [self.backgroundImageView addSubview:rightView];
}

- (void)setRightViewInsets:(UIEdgeInsets)rightViewInsets {
    
    _rightViewInsets = rightViewInsets;
    
    self.rightView.frame = UIEdgeInsetsInsetRect(self.rightView.frame, rightViewInsets);
}

#pragma mark switch functions

- (void)setOn:(BOOL)on {
    
    [self setOn:on animated:NO sendActions:NO];
}

- (void)toggleAnimated:(BOOL)animated {
    
    BOOL newStatus = !self.on;
    [self setOn:newStatus animated:animated];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    
    [self setOn:on animated:animated sendActions:YES];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated sendActions:(BOOL)sendActions {
    
    CGRect newButtonFrame;
    if (on) {
        newButtonFrame = [self rightButtonFrame];
    } else {
        newButtonFrame = [self leftButtonFrame];
    }
    CGRect newBackFrame = [self bgRectForButtonOriginX:CGRectGetMinX(newButtonFrame)];
    
    if (animated) {
        
        [UIView animateWithDuration:ANIMATION_DURATION
                         animations:^{
                             
                             self.backgroundImageView.frame = newBackFrame;
                             self.buttonImageView.frame = newButtonFrame;
                         }
                         completion:^(BOOL finished){
                             _on = on;
                             if (sendActions) [self sendActionsForControlEvents:UIControlEventValueChanged];
                         }];
    } else {
        
        [self.backgroundImageView setFrame:newBackFrame];
        [self.buttonImageView setFrame:newButtonFrame];
        _on = on;
        if (sendActions) [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - dynamic frames

- (CGFloat)height {
    return self.borderImage.size.height;
}

- (CGFloat)width {
    return self.borderImage.size.width;
}

- (CGFloat)labelWidth {
    
    CGFloat result = (self.backgroundImageView.frame.size.width - self.buttonImageView.frame.size.width)/2;
    return result;
}

- (CGRect)leftButtonFrame {
    CGRect result = CGRectMake(self.horizontalButtonOffset, 0, self.buttonImage.size.width, self.buttonImage.size.height);
    return result;
}

- (CGRect)rightButtonFrame {
    CGRect result = CGRectMake([self width] - self.buttonImage.size.width - self.horizontalButtonOffset, 0, self.buttonImage.size.width, self.buttonImage.size.height);
    return result;
}

- (CGRect)bgRectForButtonOriginX:(CGFloat)buttonOriginX {
    
    CGRect result = CGRectMake(buttonOriginX - [self width] + self.buttonImage.size.width + self.horizontalButtonOffset,
                               0,
                               self.backgroundImage.size.width,
                               [self height]);
    return result;
}

- (CGFloat)maxButtonXMovement {
    
    CGFloat result = [self width] - self.buttonImage.size.height - self.horizontalButtonOffset;
    return result;
}

#pragma mark - touch tracking

/* touch tracking code is taken and simplified by https://github.com/JamesBKelly/JKSwitch.git */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    self.firstTouchPoint = [touch locationInView:self];
    self.touchDistanceFromButton = self.firstTouchPoint.x - self.buttonImageView.frame.origin.x;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint lastTouchPoint = [touch locationInView:self];
    
    if (self.firstTouchPoint.x < lastTouchPoint.x) {
        //Move the button right
        [self.buttonImageView setFrame:CGRectMake(lastTouchPoint.x - self.touchDistanceFromButton, 0, self.buttonImage.size.width, self.buttonImage.size.height)];
    }
    else{
        //Move the button left
        [self.buttonImageView setFrame:CGRectMake(lastTouchPoint.x - self.touchDistanceFromButton, 0, self.buttonImage.size.width, self.buttonImage.size.height)];
    }
    
    //Swipe fast enough and the button will be drawn outside the bounds.
    //If so, relocate it to the left/right of the switch.
    if (self.buttonImageView.frame.origin.x > CGRectGetMinX([self rightButtonFrame])) {
        [self.buttonImageView setFrame:[self rightButtonFrame]];
    }
    else if(self.buttonImageView.frame.origin.x < CGRectGetMinX([self leftButtonFrame])) {
        [self.buttonImageView setFrame:[self leftButtonFrame]];
    }
    
    [self.backgroundImageView setFrame:[self bgRectForButtonOriginX:self.buttonImageView.frame.origin.x]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint endTouchPoint = [touch locationInView:self];
    if(self.firstTouchPoint.x > (endTouchPoint.x - TAP_SENSITIVITY) &&
       self.firstTouchPoint.x < (endTouchPoint.x + TAP_SENSITIVITY) &&
       self.firstTouchPoint.y > (endTouchPoint.y - TAP_SENSITIVITY) &&
       self.firstTouchPoint.y < (endTouchPoint.y + TAP_SENSITIVITY)){
        //TAPPED
        [self toggleAnimated:YES];
        
    } else {
        //SWIPED
        CGRect newButtonFrame;
        CGFloat currentButtonMovement;
        
        if (self.buttonImageView.center.x < self.borderImageView.center.x) {
            
            //move left
            newButtonFrame = [self leftButtonFrame];
            currentButtonMovement = CGRectGetMinX(self.buttonImageView.frame) - CGRectGetMinX(newButtonFrame);
            _on = NO;
            
        } else  {
            //move right
            newButtonFrame = [self rightButtonFrame];
            currentButtonMovement = CGRectGetMinX([self rightButtonFrame]) - CGRectGetMinX(self.buttonImageView.frame);
            _on = YES;
        }
        
        //duration shortened if we do not move from end to end
        NSTimeInterval durationFraction = (currentButtonMovement * ANIMATION_DURATION) / [self maxButtonXMovement];
        
        [UIView animateWithDuration:durationFraction
                         animations:^{
                             
                             [self.buttonImageView setFrame:newButtonFrame];
                             [self.backgroundImageView setFrame:[self bgRectForButtonOriginX:self.buttonImageView.frame.origin.x]];
                         }
                         completion:^(BOOL finished){
                             
                             [self sendActionsForControlEvents:UIControlEventValueChanged];
                         }];
    }
}

@end
