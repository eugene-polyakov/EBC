//
//  ViewController.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/18/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "ViewController.h"
#import <RestKit/RestKit.h>
#import "ModelMapping.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ModelMapping eventMapping] pathPattern:nil keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
	NSURL *URL = [NSURL URLWithString:@"https://www.eventbrite.com/json/event_get?app_key=EHHWMU473LTVEO4JFY&id=4928107101"];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [requestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult);
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
    [requestOperation start];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
