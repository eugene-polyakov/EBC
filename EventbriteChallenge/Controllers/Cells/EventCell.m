//
//  EventCell.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/22/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "EventCell.h"
#import "AFImageRequestOperation.h"

@interface EventCell()
@property (strong, nonatomic) IBOutlet UIImageView *eventImageView;
@property (strong, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (strong, nonatomic) IBOutlet UIView *colorBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end

@implementation EventCell

static UINib * __nib;
static NSDateFormatter * __fmt;

-(NSString*)formatDate:(NSDate*)date {
    if (!__fmt) {
        __fmt = [[NSDateFormatter alloc] init];
        __fmt.dateStyle = NSDateFormatterFullStyle;
    }
    NSString * ret = nil;
    @synchronized(__fmt) {
        ret = [__fmt stringFromDate:date];
    }
    return ret;
}

-(void)applyEvent:(Event*)event {
    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:event.logo]];
    AFImageRequestOperation * op = [[AFImageRequestOperation alloc] initWithRequest:req];
    self.eventImageView.backgroundColor = [UIColor clearColor];
    [self.spinner startAnimating];
    self.eventImageView.image = nil;
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.spinner stopAnimating];
        self.eventImageView.image = (UIImage*)responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.eventImageView.backgroundColor = [UIColor lightGrayColor];
        [self.spinner stopAnimating];
    }];
    [op start];
    CGSize size = [event.title sizeWithFont:self.eventTitleLabel.font constrainedToSize:CGSizeMake(self.eventTitleLabel.frame.size.width, self.frame.size.height - self.eventDateLabel.frame.size.height - 5 - self.eventTitleLabel.frame.origin.y) lineBreakMode:self.eventTitleLabel.lineBreakMode];
    CGRect f = self.eventTitleLabel.frame;
    f.size.height = size.height;
    self.eventTitleLabel.frame = f;
    self.eventTitleLabel.text = event.title;
    CGRect f1 = self.eventDateLabel.frame;
    f1.origin.y = CGRectGetMaxY(f) + 5;
    self.eventDateLabel.frame = f1;
    self.eventDateLabel.text = [self formatDate:event.startDate];
}

+(CGFloat)height {
    return 100.;
}

+(EventCell*)cellForEvent:(Event*)event {
    __nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    EventCell * cell = [[__nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    [cell applyEvent:event];
    return cell;
}

@end
