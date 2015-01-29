//
//  SignupViewController.m
//  Tinder
//
//  Created by Barry on 1/25/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "SignupViewController.h"
#import  <Parse/Parse.h>
#import "AppConstant.h"

@interface SignupViewController ()
{
    NSArray *_pickerData;
}



@end



@implementation SignupViewController

@synthesize fnameTxtfield, lnameTxtfield, unameTxtfield, passwordTxtField;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Initialize Data
    self.navigationController.navigationBarHidden = YES;
    
    self.picView.hidden = YES;
    
    _pickerData = @[@"Male", @"Female"];
    
    // Connect data
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([passwordTxtField isFirstResponder] && [touch view] != passwordTxtField) {
        [passwordTxtField resignFirstResponder];
    }
    if ([fnameTxtfield isFirstResponder] && [touch view] != fnameTxtfield) {
        [fnameTxtfield resignFirstResponder];
    }
    if ([lnameTxtfield isFirstResponder] && [touch view] != lnameTxtfield) {
        [lnameTxtfield resignFirstResponder];
    }
    if ([unameTxtfield isFirstResponder] && [touch view] != unameTxtfield) {
        [unameTxtfield resignFirstResponder];
    }

    [super touchesBegan:touches withEvent:event];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickGenderBtn:(id)sender {
    
    self.picView.hidden = NO;
}

- (IBAction)onClickGenderDone:(id)sender {
    
    self.picView.hidden = YES;
}

- (IBAction)onClickBtnClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)onClickDone:(id)sender {
    
    self.viewDatePic.hidden=YES;
    
    NSDate *birthDate = self.picDate.date;
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit; //|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:birthDate toDate:currentDate options:0];
    
    NSInteger days = [dateComponents day];
    NSInteger months = [dateComponents month];
    NSInteger years = [dateComponents year];
    
    NSLog(@"%ld Years , %ld Months , %ld Days", (long)years, (long)months, (long)days);
    
    if(years < 18)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error !!!"
                                                        message:@"You should be a minimum of 18 yrs old to Sign Up !"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
    else{
        
        PFUser *user = [PFUser user];
        user.username = self.unameTxtfield.text;
        user.password = self.passwordTxtField.text;
        //user.email = self.emailRegisterTextField.text;
        //user[PF_USER_EMAILCOPY] = self.emailRegisterTextField.text;
        user[PF_USER_FIRSTNAME] = self.fnameTxtfield.text;
        user[PF_USER_LASTNAME] = self.lnameTxtfield.text;
        user[PF_USER_SEX] = self.genderLabel.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
//                [self dismissViewControllerAnimated:YES completion:^{
//                    if ([_parent isKindOfClass:[HomeViewController class]]) {
//                        HomeViewController *vc=(HomeViewController *)_parent;
//                        //[vc onClickbtnFBLogin:nil];
//                    }
//                }];
                
//                HomeViewController *vc=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
//                vc.parent=self;
//                [self presentViewController:vc animated:YES completion:^{
//                    
//                }];
                //The registration was succesful, go to the wall
                //[self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
                PFUser *currentUser = [PFUser currentUser];
                //[[User currentUser]setUser];
                if (currentUser){
                HomeViewController *home ;
                home._loadViewOnce = YES;
                if (IS_IPHONE_5)
                {
                    home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                }
                else
                {
                    home = [[HomeViewController alloc] initWithNibName:@"HomeViewController_ip4" bundle:nil];
                }
                home.didUserLoggedIn = YES;
                home._loadViewOnce = YES;
                NSMutableArray *navigationarray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                [navigationarray removeAllObjects];
                [navigationarray addObject:home];
                [self.navigationController setViewControllers:navigationarray animated:YES];
                }
                
            } else {
                //Something bad has ocurred
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }];
        
    }

}

- (IBAction)onClickSignup:(id)sender {
    
    if ([fnameTxtfield.text  isEqual: @""] || [lnameTxtfield.text  isEqual: @""] || [unameTxtfield.text  isEqual: @""] || [passwordTxtField.text  isEqual: @""] || [_genderLabel.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Please complete all fields."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else{
    
    self.viewDatePic.hidden=NO;
    //self.picker.hidden = YES;
    self.picView.hidden = YES;
    }
}


// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    
    NSString *resultString = _pickerData[row];
    
    _genderLabel.text = resultString;
}
@end
