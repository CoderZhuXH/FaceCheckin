//
//  NGUserPanelController.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGUserPanelController.h"
#import "NGDailyReportCellObject.h"
#import "NGHourlyStatus.h"

#import <QuartzCore/QuartzCore.h>

@interface NGUserPanelController ()

@property (nonatomic, strong) NSArray * loginArray;
@property (nonatomic, strong) CUCellDataSource * dataSource;

@property (weak, nonatomic) IBOutlet NGHourlyStatus *hourlyStatusManager;

@property (weak, nonatomic) IBOutlet UITableView *dataLoginView;

@end

@implementation NGUserPanelController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)doCheckin:(id)sender {
    
    if(self.hourlyStatusManager.sessionInProgress) {
        [self.hourlyStatusManager clockOut];
    } else {
        [self.hourlyStatusManager clockIn];
    }
    
    [self updateCheckinButtonText];
}

- (void)updateCheckinButtonText {
    if(self.hourlyStatusManager.sessionInProgress) {
        [self.checkinButton setTitle:@"ULTIMATE CLOCK OUT BUTTON" forState:UIControlStateNormal];
    } else {
        [self.checkinButton setTitle:@"ULTIMATE CLOCK IN BUTTON" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginArray = [NGDailyReportCellObject cellObjectsFromReportData:[NGDailyReportCellObject mockSomeData]];
    self.dataSource = [[CUCellDataSource alloc] initWithArray:self.loginArray withDelegate:self];
    
    self.dataLoginView.dataSource = self.dataSource;
    
    CALayer * lyr = [CALayer layer];
    lyr.frame = CGRectMake(0, 0, self.dataLoginView.frame.size.width, 1);
    lyr.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.8 alpha:1].CGColor;
    
    [self.dataLoginView.layer addSublayer:lyr];
    
    [self.dataLoginView reloadData];
    
    [self updateCheckinButtonText];

    
	// Do any additional setup after loading the view.
}

- (UITableViewCell *)CUTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath forObject:(id)userData {
    return [CUCellGenerator CUTableView:tableView atIndexPath:indexPath forObject:userData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end