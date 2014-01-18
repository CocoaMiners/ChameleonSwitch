//
//  VKRSChameleonSwitch.h
//  Weight Me
//
//  Created by Vilem Kurz on 24/05/2013.
//  Copyright (c) 2013 Cocoa Miners.

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

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

/* background image width must be (border.width - button.width/2 - horizontalButtonOffset) * 2. Background, button, border must be of equal height. The size of the switch will be the size of the background image */

- (id)initWithOrigin:(CGPoint)origin
     backgroundImage:(UIImage *)bgImage
         buttonImage:(UIImage *)buttonImage
         borderImage:(UIImage *)borderImage;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
