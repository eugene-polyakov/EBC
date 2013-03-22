//
//  TagCloudViewController+Graphics.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/22/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "TagCloudViewController.h"
#import "TagView.h"
#import "CloudView.h"
#import "UIImage+PDF.h"
#import <AVFoundation/AVFoundation.h>

static NSArray * __fonts;

@implementation TagCloudViewController (Graphics)

-(void)loadFonts {
    NSString * error = nil;
    __fonts = [[NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fonts" ofType:@"plist"] ] mutabilityOption:NSPropertyListImmutable format:nil errorDescription:&error] allValues];

}

-(void)lockDown {
    [self.tagView lockDown];
}

-(void)releaseLock {
    [self.tagView releaseLock];
}

-(void)addViewForTag:(NSString*)tag z:(int)z {
    if (!__fonts) {
        [self loadFonts];
    }
    TagCloudView * t = self.tagView;
    TagView * v = [TagView buttonWithType:UIButtonTypeCustom];
    v.tagName = tag;
    v.z = z+arc4random_uniform(4)-2;
    if (v.z <=0) v.z = 1;
    [v setTitle:tag forState:UIControlStateNormal];
    [v addTarget:self action:@selector(lockDown) forControlEvents:UIControlEventTouchDown];
    [v addTarget:self action:@selector(releaseLock) forControlEvents:UIControlEventTouchUpOutside];
    [v setTitleColor:[UIColor colorWithHue:arc4random_uniform(255)/255. saturation:.3 brightness:.5 alpha:MAX(1./z, .7)] forState:UIControlStateNormal];
    [v setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    float fontSize = MAX(40-z*3., 10);
    int fontNo = arc4random_uniform(__fonts.count);
    UIFont * font = [UIFont fontWithName:[__fonts objectAtIndex:fontNo] size:fontSize];
    [v.titleLabel setFont:font];
    v.titleLabel.numberOfLines = 3;
    v.titleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize size = [tag sizeWithFont:font constrainedToSize:CGSizeMake(300, 300)];
    [v setFrame:CGRectMake(arc4random_uniform(t.frame.size.width), arc4random_uniform(t.frame.size.height), size.width, size.height+fontSize)];
    v.originalSize = v.frame.size;
    v.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [v addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [t addFlyingObject:v];
}

-(void)buttonTap {
    
}

-(void)playSound {
    NSError *error;
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"wheeee" withExtension:@"aiff"];
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer play];
}

-(void)addTwoClouds {
    [self addClouds:2];
}

-(void)addClouds:(int)number {
    TagCloudView * t = [self tagView];
    for (int i = 0; i < number; i++) {
        int z = arc4random_uniform(number*3)+1;
        int height = number*40-z*10;
        UIImage * img = [UIImage imageWithPDFNamed:@"cloud1_.pdf" atHeight:height];
        CloudView * v = [[CloudView alloc] initWithImage:img];
        CGPoint center = CGPointMake(arc4random_uniform(t.frame.size.width), arc4random_uniform(t.frame.size.height));
        v.frame = CGRectMake(center.x, center.y, 0, 0);
        v.originalSize = img.size;
        [UIView animateWithDuration:CLOUD_ANIMATION_DURATION/2 animations:^{
            v.frame = CGRectMake(center.x - v.originalSize.width/2, center.y - v.originalSize.height/2, v.originalSize.width, v.originalSize.height);
        }];
        v.z = z;
        [t addFlyingObject:v];
        v.userInteractionEnabled = YES;
        v.tapBlock = ^(CloudView* v) {
            [self playSound];
            [UIView animateWithDuration:CLOUD_ANIMATION_DURATION/2 delay:0 options:0 animations:^{
                CGRect frame = CGRectMake(v.center.x, v.center.y, 0, 0);
                v.frame = frame;
            } completion:^(BOOL finished) {
                [t removeFlyingObject:v];
                [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(addTwoClouds) userInfo:nil repeats:NO];
            } ];
        };
    }
}


@end
