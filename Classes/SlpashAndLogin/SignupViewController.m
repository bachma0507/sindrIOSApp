//
//  SignupViewController.m
//  Tinder
//
//  Created by Barry on 1/25/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "SignupViewController.h"

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

}

- (IBAction)onClickSignup:(id)sender {
    
    self.viewDatePic.hidden=NO;
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
}
@end
