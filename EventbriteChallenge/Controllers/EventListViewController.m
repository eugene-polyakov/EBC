//
//  EventListControllerViewController.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/22/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "EventListViewController.h"
#import "Model.h"

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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Event * event = [self.events objectAtIndex:indexPath.row];
    cell.textLabel.text = event.title;
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.tagView;
    CGPoint ctr = self.backButton.center;
    ctr.y = self.tagView.frame.size.height / 2;
    ctr.x = ctr.y;
    self.backButton.center = ctr;
    [self.tagView addSubview:self.backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
