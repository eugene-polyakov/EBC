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

@interface TagCloudViewController () <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) CLLocation * lastKnownLocation;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) UIAlertView * alertView;
@property (nonatomic, strong) NSMutableDictionary * data;

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
          
          int maxCount = 0;
          NSDictionary * dic = [DataUtils groupedDictionaryOfEvents:mappingResult.array maxCount:&maxCount];
          self.data = [dic mutableCopy];
                    
          for (id key in dic.allKeys) {
              NSSet * events = [dic objectForKey:key];
              int z = maxCount / events.count;
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

-(void)buttonTap:(TagView*)tagView {
    NSString * tag = tagView.tagName;
    NSSet * events = [self.data objectForKey:tag];
}

-(void)dealloc {
    [self stopTracking];
}

@end
