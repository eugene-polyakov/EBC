//
//  HintManager.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/22/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "HintManager.h"
#import "NSTimer+Blocks.h"
#import "UIImage+PDF.h"



@implementation HintManager

+(HintManager*)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)removeBtn:(UIButton*)sender {
    [UIView animateWithDuration:.3 delay:0 options:0 animations:^{
        sender.alpha = 0.;
    } completion:^(BOOL finished) {
        [sender removeFromSuperview];
    }];
}

+(void)showHint:(NSString*)hint inView:(UIView*)v afterDelay:(NSTimeInterval)delay key:(NSString*)key {
    if (YES) {//    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [NSTimer scheduledTimerWithTimeInterval:delay block:^{
            UIFont * font = [UIFont systemFontOfSize:25];
            CGSize size = [hint sizeWithFont:font constrainedToSize:CGSizeMake(300, 300) lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat calloutHeight = size.height * 3;
            UIImage * callout = [UIImage imageWithPDFNamed:@"callout.pdf" atHeight:calloutHeight];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(callout.size.width * .1, calloutHeight * .1, callout.size.width * .8, size.height)];
            label.text = hint;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 3;
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            UIButton * img = [UIButton buttonWithType:UIButtonTypeCustom];
            img.frame = CGRectMake(0, v.frame.size.height - callout.size.height, callout.size.width, callout. size.height);
            [img addSubview:label];
            [img setBackgroundImage:callout forState:UIControlStateNormal];
            [v addSubview:img];
            img.alpha = 0;
            [img addTarget:[HintManager sharedInstance] action:@selector(removeBtn:) forControlEvents:UIControlEventTouchUpInside];
            [UIView animateWithDuration:.2 animations:^{
                img.alpha = 1.;
            }];
            [NSTimer scheduledTimerWithTimeInterval:3. block:^{
                [[HintManager sharedInstance] removeBtn:img];
            } repeats:NO];
        } repeats:NO];
    }
}

@end
