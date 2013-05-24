//
//  VKRSChameleonSwitch.h
//  Weight Me
//
//  Created by Vilem Kurz on 24/05/2013.
//  Copyright (c) 2013 Cocoa Miners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKRSChameleonSwitch : UIControl

/* views are resized to fill the space between button and background view edges */
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;

/* set these if you wish to displace the views */
@property (nonatomic) UIEdgeInsets rightViewInsets;
@property (nonatomic) UIEdgeInsets leftViewInsets;

/* set this, if you wish to leave space between left/right border of the switch and edge button positions. The default is 0. */
@property (nonatomic) CGFloat horizontalButtonOffset;

@property(nonatomic, getter=isOn) BOOL on;

/* background image width must be (border.width - button.width/2 - padding) * 2. Background, button, border must be of equal height. The size of the switch will be the size of the background image */

- (id)initWithOrigin:(CGPoint)origin
     backgroundImage:(UIImage *)bgImage
         buttonImage:(UIImage *)buttonImage
         borderImage:(UIImage *)borderImage;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
