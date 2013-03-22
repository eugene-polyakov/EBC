//
//  TagCloudViewController.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/20/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "TagCloudViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <RestKit/RestKit.h>
#import "AppContext.h"
#import "MBProgressHUD.h"
#import "Model.h"
#import "DataUtils.h"
#import "TagCloudView.h"
#import "TagView.h"
#import "HintManager.h"
#import "EventListViewController.h"

@interface TagCloudViewController () <CLLocationManagerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) CLLocation * lastKnownLocation;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) UIAlertView * alertView;
@property (nonatomic, strong) NSMutableDictionary * data;
@property (nonatomic, strong) UIPopoverController * popover;
@property (nonatomic, strong) TagView * selectedTag;

@end

@implementation TagCloudViewController

static NSTimeInterval const MIN_LOCATION_INTERVAL = 60;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


-(void)locate {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationManager startUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self locate];
    [self addClouds:3];
    [self startTracking];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationUpdateComplete {
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
	hud.labelText = NSLocalizedString(@"Loading data...", nil);
	hud.taskInProgress = YES;
	hud.graceTime = 0.1;
    [hud show:YES];
    [self.view addSubview:hud];
    NSMutableDictionary * params = [AppCTX parametersDictionaryWithAPIKey];
    [params setObject:@"15" forKey:@"max"];
    [params setObject:[NSNumber numberWithDouble:self.lastKnownLocation.coordinate.latitude] forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:self.lastKnownLocation.coordinate.longitude] forKey:@"longitude"];
    [params setObject:@"20" forKey:@"within"];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/json/event_search" parameters:
                                              params
      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

          [hud hide:YES];
          
          [self.tagView removeAll];
          [self addClouds:4];
          int maxCount = 0;
          NSDictionary * dic = [DataUtils groupedDictionaryOfEvents:mappingResult.array maxCount:&maxCount];
          self.data = [dic mutableCopy];
                    
          for (id key in dic.allKeys) {
              NSSet * events = [dic objectForKey:key];
              int z = maxCount / events.count;
              // let's just use number of events for this tag as a measure
              [self addViewForTag:key z:z];
          }
          
          [HintManager showHint:NSLocalizedString(@"Try to tilt\nyour device !", nil) inView:self.view afterDelay:2. key:@"tilt"];
          
      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
          [hud hide:YES];
          NSLog(@"Not OK");
      }];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.lastKnownLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.775192,-122.399776) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]];
    [self locationUpdateComplete];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString * title = NSLocalizedString(@"Cannot determine location", nil);
    NSString * msg = NSLocalizedString(@"Let's assume you're at\n651 Brannan St", nil);
    if (!self.alertView) {
        self.alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [self.alertView show];
    }
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * latest = [locations objectAtIndex:0];
    // Let's protect from too frequent updates. once per minute max
    if (!self.lastKnownLocation || [latest.timestamp timeIntervalSinceDate:self.lastKnownLocation.timestamp] >= MIN_LOCATION_INTERVAL) {
        self.lastKnownLocation = [locations objectAtIndex:0];
        [self locationUpdateComplete];
    }
    [manager stopUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated {
    [UIView animateWithDuration:.3 animations:^{
        self.tagView.alpha = 1.;
        self.background.alpha = 1.;
    }];
    [self.tagView releaseLock];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popover = nil;
    [self.tagView releaseLock];
    self.selectedTag.selected = NO;
    self.selectedTag = nil;
}

-(void)buttonTap:(TagView*)tag {
    NSString * tagName = tag.tagName;
    NSSet * events = [self.data objectForKey:tagName];
    BOOL iPad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    if (iPad) {
        EventListViewController * ctrl = [[EventListViewController alloc] initWithTagView:nil events:events];
        tag.selected = YES;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:ctrl];
        [self.popover presentPopoverFromRect:tag.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.selectedTag = tag;
        self.popover.delegate = self;
    }
    else {
        tag.frame = [tag convertRect:tag.bounds toView:self.view];
        [self.view addSubview:tag];
        [UIView animateWithDuration:.3 animations:^{
            self.tagView.alpha = 0.;
            self.background.alpha = 0.;
            tag.frame = CGRectMake(0,0,self.view.frame.size.width,tag.frame.size.height);
        } completion:^(BOOL finished) {
            [tag removeTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventAllEvents];
            EventListViewController * ctrl = [[EventListViewController alloc] initWithTagView:tag events:events];
            [self.navigationController pushViewController:ctrl animated:NO];
        }];
    }
}

-(void)dealloc {
    [self stopTracking];
}

@end
