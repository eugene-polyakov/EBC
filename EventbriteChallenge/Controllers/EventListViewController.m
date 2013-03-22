//
//  EventListControllerViewController.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/22/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "EventListViewController.h"
#import "Model.h"
#import "EventCell.h"

@interface EventListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) TagView * tagView;
@property (nonatomic, strong) NSArray * events;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EventListViewController

-(IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}


-(id)initWithTagView:(TagView*)tagView events:(NSSet*)events {
    if (self = [super init]) {
        self.tagView = tagView;
        self.events = [events allObjects];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Event * event = [self.events objectAtIndex:indexPath.row];
    EventCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [EventCell cellForEvent:event];
    } else {
        [cell applyEvent:event];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EventCell height];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.tagView;
    self.backButton.frame = CGRectMake(0, 0, self.tagView.frame.size.height, self.tagView.frame.size.height);
    [self.tagView addSubview:self.backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
