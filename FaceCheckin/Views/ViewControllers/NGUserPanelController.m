//
//  NGUserPanelController.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGUserPanelController.h"
#import "NGDailyReportCellObject.h"
#import "NGDailyTimeClockData.h"
#import "NGHourlyStatus.h"

#import "NGEmployeeData.h"

#import "NGCloudObjectAPI.h"
#import "NGTimeClockCloudObject.h"

#import "NGFaceRecognitionResult.h"
#import "NGFaceRecognitionAlbum.h"
#import "NGImageRecognizer.h"
#import "NGCheckinData.h"

#import "MBProgressHUD.h"
#import "NGProfileInfo.h"

#import "NSDate+NGExtensions.h"

#import <QuartzCore/QuartzCore.h>

@interface NGUserPanelController ()

@property (nonatomic, strong) NSArray * checkinsArrayFromAPI;
@property (nonatomic, strong) NSArray * loginArray;

@property (nonatomic, strong) CUCellDataSource * dataSource;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NGHourlyStatus *hourlyStatusManager;
@property (weak, nonatomic) IBOutlet UITableView *dataLoginView;

@property (weak, nonatomic) IBOutlet NGProfileInfo *profileInfoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, strong) MBProgressHUD * loadingHud;

@property (nonatomic, strong) NGTimeClockCloudObject * todayData;
@property (nonatomic, strong) NGDailyTimeClockData * todayTableSlot;


@property (weak, nonatomic) IBOutlet UILabel *totalHours;
@property (weak, nonatomic) IBOutlet UILabel *totalHoursReal;


@property (weak, nonatomic) IBOutlet VGMultistateButton *mutlistateCheckinButton;

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
        self.todayData.dateCheckingOut   = [self.hourlyStatusManager clockOut];
    } else {
        self.todayData.dateCheckingIn  = [self.hourlyStatusManager clockIn];
    }
    
    if([self.todayData isReadyToSend]) {
        [self.todayData uploadData:^(NSError *error) {
            
            NGCheckinData * data = [[NGCheckinData alloc] initWithCheckIn:self.todayData.dateCheckingIn andCheckout:self.todayData.dateCheckingOut];
            
            BOOL good = [self.todayTableSlot insertCheckinData:data];
            
            if(good) {
                NSLog(@"Adding new data to today!");
            }
            
            [self reloadDataSource];
            
            self.todayData = (NGTimeClockCloudObject *)[self.todayData cloudObjectWithEmployeeIdAndName];
            self.loadingHud.labelText = @"Done!";
            [self.loadingHud hide:YES afterDelay:1.0f];
        }];
        
        self.loadingHud.labelText = @"Checking in...";
        [self.loadingHud show:YES];
    }
    
    [self updateCheckinButtonText];
}

- (void)updateCheckinButtonText {
    if(self.hourlyStatusManager.sessionInProgress) {
        [self.checkinButton setTitle:@"CLOCK OUT" forState:UIControlStateNormal];
    } else {
        [self.checkinButton setTitle:@"CLOCK IN" forState:UIControlStateNormal];
    }
}

- (void)button:(VGMultistateButton *)button didChangeStateTo:(NSString *)state {
    [self doCheckin:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData * imageData = UIImagePNGRepresentation(self.imageToShow);
    
    self.loadingHud                 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHud.mode            = MBProgressHUDAnimationFade;
    self.loadingHud.labelText       = @"Identifying person...";
    
    [NGFaceRecognitionResult getRecognitionResulsForImageData:imageData forNameSpace:@"NG_TEST" withResult:^(NGFaceRecognitionResult *result, NSError *error) {

        NGFaceRecognitionPhotoResult * res = [result.photos objectAtIndex:0];
        NSArray * frUUIDs = [res getUUIDsForNamespace:result.nameSpace];
        
        
        if(res.facesOnPicture != 1) {
            [self.loadingHud hide:YES];
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Multiple faces found!" message:@"We're sorry, but there's more then one face on the picture. Please repeat the photograph!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            return;
        }
        
        NGFaceRecognitionUUID * firstObject = [frUUIDs objectAtIndex:0];
        
        if(firstObject) {
            if (firstObject.confidence > 80) {
                NSString * employeeHiddenId = [NGEmployeeData encryptedIdForId:firstObject.strippedUid];
                [self loadUserDetailsByEncryptedId:employeeHiddenId];
                self.loadingHud.labelText = @"Person found! Loading person data...";
            } else {
                [self.loadingHud hide:YES];
                UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Cannot find people in picutre" message:@"We may have found a person we know, but our system is not accurate enough to determine it is exactly you. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];

            }
        } else {
            [self.loadingHud hide:YES];
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Cannot find people in picutre" message:@"We're sorry, but our System cannot identify the person in the image. Please retake the photo to try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }];
    
    self.checkinsArrayFromAPI   = [NGDailyTimeClockData getPlaceholders];
    
    NSDate * today = [[NSDate date] dateByStrippingHours];
    
    for (NGDailyTimeClockData * data in self.checkinsArrayFromAPI) {
        if([data.dayInfo compare:today] == NSOrderedSame) {
            self.todayTableSlot = data;
            break;
        }
    }
    
    [self reloadDataSource];
    
    CALayer * lyr = [CALayer layer];
    lyr.frame = CGRectMake(0, 0, self.dataLoginView.frame.size.width, 1);
    lyr.backgroundColor = [UIColor colorWithHue:202.0f/360.0f saturation:0.3 brightness:0.25 alpha:1].CGColor;

    [self.dataLoginView.layer addSublayer:lyr];
    
    [[NGCoreTimer coreTimer] registerListener:self];
    self.totalHours.font = [UIFont fontWithName:@"GothamNarrow-Bold" size:24];
    self.totalHoursReal.font = [UIFont fontWithName:@"GothamNarrow-Bold" size:24];
    self.hourLabel.font = [UIFont fontWithName:@"GothamNarrow-Bold" size:22];
    
    NSArray * states = [VGMultistateButton createClockinButtonStates];
    [self.mutlistateCheckinButton forceStates:states];
    self.mutlistateCheckinButton.delegate = self;

    [self updateCheckinButtonText];
    
    [self.imageView setImage:self.imageToShow];

    
	// Do any additional setup after loading the view.
}

- (void)loadUserDetailsByEncryptedId:(NSString *)encryptedId {
    
    [NGEmployeeData getEmployeeDataForEncryptedID:encryptedId forCallback:^(NGEmployeeData *data, NSError *error) {

        [self.loadingIndicator stopAnimating];
        self.profileInfoView.hidden = NO;
        
        [self.profileInfoView loadPerfsFromProfile:data];

        
        if (error == nil) {
            self.loadingHud.labelText = [NSString stringWithFormat:@"Hello, %@! Loading Your clockin data...", data.firstName];
            [self loadCloudObject:@"Time_Clock" forUser:data];
        } else {
            self.loadingHud.labelText = [NSString stringWithFormat:@"Failed loading user data... aborting.", nil];
            [self.loadingHud hide:YES afterDelay:1.5f];
        }
        
    }];
}

+ (NSString *)buildKeyForEmployeeId:(NSString *)empId {
    return [NSString stringWithFormat:@"%@_%@",currentCheckinKey, empId];
}

- (void)loadCloudObject:(NSString *)cloudObjectId forUser:(NGEmployeeData *)employee {
    
    [NGTimeClockCloudObject getCloudObjectForEmployeeData:employee withCallback:^(NSArray *cloudObjects, NSError *error) {
        
        self.loadingHud.labelText = [NSString stringWithFormat:@"And we're done! You can now clock in normally.", nil];
        [self.loadingHud hide:YES afterDelay:1.5f];
        
        NSArray * arrOfDailyTimeClockData = [NGDailyTimeClockData createDailyClockDataFromCloudObjects:cloudObjects]; // we have data... BITCH!
        
        
        NSDate * startWatchDate = [[self.checkinsArrayFromAPI objectAtIndex:0] dayInfo];
        
        NSInteger startIndex = -1;
        
        for(int i = 0; i < arrOfDailyTimeClockData.count; i++) {
            NGDailyTimeClockData * data = [arrOfDailyTimeClockData objectAtIndex:i];
            
            if(startIndex < 0) {
                
                if(DATE_GT_OR_EQUAL(data.dayInfo, startWatchDate) ) {
                    startIndex = i;
                    break;
                }
            }
        }
        
        // fill existing data
        if(startIndex > 0) {
            NSInteger counter = 0;            
            NSDate * today = [[NSDate date] dateByStrippingHours];
            
            for(int i = startIndex; i < arrOfDailyTimeClockData.count && i < startIndex + 7; i++) {
                
                NGDailyTimeClockData * data = [self.checkinsArrayFromAPI objectAtIndex:counter++];
                NGDailyTimeClockData * apiData = [arrOfDailyTimeClockData objectAtIndex:i];
                
                if([data.dayInfo compareByDates:apiData.dayInfo] != NSOrderedSame) {
                    i--;
                    continue;
                }
                
                for (NGCheckinData * cData in apiData.checkins) {
                    BOOL wereCool = [data insertCheckinData:cData];
                    NSAssert(wereCool, @"Inserting Checkin data of %@ to %@. Wrong.", apiData.dayInfo, data.dayInfo);
                }
                
                if([apiData.dayInfo compare:today] == NSOrderedSame) {
                    [self.hourlyStatusManager loadCheckinData:data];
                }
            }
        }
        
        
        // handle misc
        self.todayData = (NGTimeClockCloudObject *)[NGTimeClockCloudObject templateWithEmployeeId:employee.employeeNumber andName:[NSString stringWithFormat:@"%@ %@",employee.firstName,employee.lastName]];

        NSString * key = [[self class] buildKeyForEmployeeId:self.todayData.employeeNumber];
        
        id result = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if(result && [[result objectForKey:jkCloudObjectEmployeeNumber] isEqualToString:employee.employeeNumber]) {
            
            self.todayData = [[NGTimeClockCloudObject alloc] initWithDictionary:result];
            
            NGCheckinData * data = [[NGCheckinData alloc] initWithCheckIn:self.todayData.dateCheckingIn andCheckout:nil];
            NGDailyTimeClockData * d = [[NGDailyTimeClockData alloc] initBasic:[NSDate date]];
            [d insertCheckinData:data];
            
            [self.hourlyStatusManager loadCheckinData:d];
        }
        
        [self reloadDataSource];
    }];
}

- (void)commitCheckin:(NGCheckinData *)checkinData {
    
}

- (void)reloadDataSource {
    NSAssert(self.checkinsArrayFromAPI != nil, @"self.checkinsArrayFromAPI cannot be nil");
    
    self.loginArray             = [NGDailyReportCellObject cellObjectsFromReportData:self.checkinsArrayFromAPI];
    self.dataSource             = [[CUCellDataSource alloc] initWithArray:self.loginArray withDelegate:self];
    
    self.dataLoginView.dataSource = self.dataSource;

    
    CGFloat hours = [self.checkinsArrayFromAPI totalHoursFromNGDailyTimeClockDataArray];
    self.totalHoursReal.text = [NSString stringWithFormat:@"%.2f", hours];
    
    [self.dataLoginView reloadData];
}

- (void)coreTimer:(NGCoreTimer *)timer timerChanged:(id)changedData {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:m a"];
    
    self.hourLabel.text = [formatter stringFromDate:[NSDate date]];
}

- (IBAction)onTap:(id)tap {
    [self.navigationController popViewControllerAnimated:YES];

    NSString * key = [[self class] buildKeyForEmployeeId:self.todayData.employeeNumber];
    
    if(self.todayData.dateCheckingIn) {
        NSDictionary * outWithIt = [self.todayData dictionaryRepresentation];
        
        [[NSUserDefaults standardUserDefaults] setObject:outWithIt forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
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