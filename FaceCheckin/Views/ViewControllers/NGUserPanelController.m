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
#import "NGEmployeeData.h"

#import "NGFaceRecognitionResult.h"
#import "NGFaceRecognitionAlbum.h"
#import "NGImageRecognizer.h"

#import "MBProgressHUD.h"

#import <QuartzCore/QuartzCore.h>

@interface NGUserPanelController ()

@property (nonatomic, strong) NSArray * loginArray;
@property (nonatomic, strong) CUCellDataSource * dataSource;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NGHourlyStatus *hourlyStatusManager;
@property (weak, nonatomic) IBOutlet UITableView *dataLoginView;

@property (nonatomic, strong) MBProgressHUD * loadingHud;

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
    
    UITapGestureRecognizer * r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.imageView addGestureRecognizer:r];
    
    NSData * imageData = UIImagePNGRepresentation(self.imageToShow);
    
    self.loadingHud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHud.mode            = MBProgressHUDAnimationFade;
    self.loadingHud.labelText       = @"Identifying person...";
    
    [NGFaceRecognitionResult getRecognitionResulsForImageData:imageData forNameSpace:@"NG_TEST" withResult:^(NGFaceRecognitionResult *result, NSError *error) {
        self.loadingHud.labelText = @"Loading person data... almost there!";
        [self loadUserDetailsByEncryptedId:@"28902ae038ce43c0bfbff78dad1bad5a"];
    }];
    
    self.loginArray = [NGDailyReportCellObject cellObjectsFromReportData:[NGDailyReportCellObject mockSomeData]];
    self.dataSource = [[CUCellDataSource alloc] initWithArray:self.loginArray withDelegate:self];
    
    self.dataLoginView.dataSource = self.dataSource;
    
    CALayer * lyr = [CALayer layer];
    lyr.frame = CGRectMake(0, 0, self.dataLoginView.frame.size.width, 1);
    lyr.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.8 alpha:1].CGColor;
    
    [self.dataLoginView.layer addSublayer:lyr];
    
    [self.dataLoginView reloadData];
    
    [self updateCheckinButtonText];
    
    [self.imageView setImage:self.imageToShow];

    
	// Do any additional setup after loading the view.
}

- (void)loadUserDetailsByEncryptedId:(NSString *)encryptedId {
    
    [NGEmployeeData getEmployeeDataForEncryptedID:encryptedId forCallback:^(NGEmployeeData *data, NSError *error) {
        self.loadingHud.labelText = [NSString stringWithFormat:@"Complete! Hello, %@", data.firstName];
        [self.loadingHud hide:YES afterDelay:1.5f];
    }];
}

- (void)onTap:(id)tap {
    [self.navigationController popViewControllerAnimated:YES];
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