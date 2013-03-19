//
//  NGLoginController.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/18/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGLoginController.h"
#import "NGTextField.h"
#import "UIView+NGExtensions.h"
#import "NGPopoverBackgroundView.h"
#import "NGCallHelpViewController.h"

#import <QuartzCore/QuartzCore.h>

#define LoginButtonPoint CGPointMake(336, 488)

@interface NGLoginController ()

////////////////////////////////////////////////// -> Fixed Views

@property (weak, nonatomic) IBOutlet NGTextField *usernameField;
@property (weak, nonatomic) IBOutlet NGTextField *passwordField;

@property (weak, nonatomic) IBOutlet UILabel *userPassHelp;
@property (weak, nonatomic) IBOutlet UIImageView *hrCloudLogoImage;

////////////////////////////////////////////////// -> Variable views depends on mode

@property (strong, nonatomic) IBOutlet UIButton *onboardButton;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UILabel *optInTextField;

////////////////////////////////////////////////// -> Variable views depends on mode

@property (nonatomic, strong) UIPopoverController * popover;

////////////////////////////////////////////////// -> Other view shit

- (void)configureViewForMode;
- (IBAction)dismissFields:(id)sender;
- (IBAction)operationClicked:(id)sender;
- (void)userPassHelpPressed:(id)sender;

@end

@implementation NGLoginController {
    UITextField * activeField;
    CGSize currentKeyboardSize;
}

- (id)initWithLoginControllerMode:(NGLoginControllerMode)mode {
    self = [self initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    if (self) {
        _currentMode = mode;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    [self configureViewForMode];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPassHelpPressed:)];
    [self.userPassHelp addGestureRecognizer:tap];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - View config shite


- (void)configureViewForMode {
    
    self.usernameField.titleImage = [UIImage imageNamed:@"Pic1"];
    self.passwordField.titleImage = [UIImage imageNamed:@"Pic2.jpeg"];

    self.usernameField.delegate = self.passwordField.delegate = self;
    
    switch (self.currentMode) {
        case NGLoginControllerModeOnboard:
        {
            [self.onboardButton moveToPoint:LoginButtonPoint];
            [self.view addSubview:self.onboardButton];
         

            self.optInTextField.layer.opacity = 0;
            self.optInTextField.center = CGPointMake(512, 282);
            [self.view addSubview:self.optInTextField];
            
            [self.view setNeedsLayout];
            [self.view setNeedsDisplay];
            
            self.hrCloudLogoImage.transform = CGAffineTransformIdentity;
            
            double delayInSeconds = DefaultAnimationDuration * 2.0f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                
                [UIView animateWithDuration:DefaultAnimationDuration * 2.0f
                                 animations:^{
                                     self.hrCloudLogoImage.transform = CGAffineTransformTranslate(self.hrCloudLogoImage.transform, 0, -50);
                                 }
                                 completion:^(BOOL finished) {
                                     [UIView animateWithDuration:DefaultAnimationDuration animations:^{
                                         self.optInTextField.layer.opacity = 1.0f;
                                     } completion:^(BOOL finished) {
                                     }];
                }];
            });
        }
            break;
        case  NGLoginControllerModeSignIn:
        {
            [self.signInButton moveToPoint:LoginButtonPoint];
            [self.view addSubview:self.signInButton];
        }
            break;
        default:
            break;
    }
    
}

- (IBAction)operationClicked:(id)sender {
    
    
}

- (void)userPassHelpPressed:(id)sender {
 
    NGCallHelpViewController * help = [[NGCallHelpViewController alloc] init];
    help.contentSizeForViewInPopover = CGSizeMake(200, 80);
    UIPopoverController * ppo = [[UIPopoverController alloc] initWithContentViewController:help];
    ppo.popoverBackgroundViewClass = [NGPopoverBackgroundView class];
    ppo.delegate = self;
    self.popover = ppo;
    
    [self.popover presentPopoverFromRect:self.userPassHelp.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


#pragma mark - Text field editing keyboard hacks. Great...

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
    [self doTranslateWithDuration:[NSNumber numberWithFloat:DefaultAnimationDuration]];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.usernameField]) {
        [self.passwordField becomeFirstResponder];
    }
    if ([textField isEqual:self.passwordField]) {
        // do login
        [self.passwordField resignFirstResponder];
    }
    
    return NO;
}

- (IBAction)dismissFields:(id)sender {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return YES;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    currentKeyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSNumber * num = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [self doTranslateWithDuration:num];
}

- (void)doTranslateWithDuration:(NSNumber *)animationDuration {
    
    // uknown size of keyboard, aborting...
    if(CGSizeEqualToSize(currentKeyboardSize, CGSizeZero)) {
        return;
    }
    
    CGRect testerFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    testerFrame.size.height -= currentKeyboardSize.width;
    
    CGPoint testPoint = CGPointMake(activeField.frame.origin.x, activeField.frame.origin.y + activeField.frame.size.height);
    
    if (!CGRectContainsPoint(testerFrame, testPoint)) {
        [UIView animateWithDuration:animationDuration.floatValue
                         animations:^{
                             self.view.transform = CGAffineTransformMakeTranslation(0, testerFrame.size.height - testPoint.y - 12);
                         }];
    } else {
        [UIView animateWithDuration:animationDuration.floatValue
                         animations:^{
                             self.view.transform = CGAffineTransformIdentity;
                         }];
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.view.transform = CGAffineTransformIdentity;
    currentKeyboardSize = CGSizeZero;
}

#pragma mark -

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}



@end
