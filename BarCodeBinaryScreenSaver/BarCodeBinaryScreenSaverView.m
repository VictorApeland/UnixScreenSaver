//
//  BarCodeBinaryScreenSaverView.m
//  BarCodeBinaryScreenSaver
//
//  Created by Victor Apeland on 14/08/2019.
//  Copyright © 2019 Victor Apeland. All rights reserved.
//

#import "BarCodeBinaryScreenSaverView.h"

@implementation BarCodeBinaryScreenSaverView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
