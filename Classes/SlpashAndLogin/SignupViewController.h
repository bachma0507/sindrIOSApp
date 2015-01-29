//
//  SignupViewController.h
//  Tinder
//
//  Created by Barry on 1/25/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface SignupViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic,strong)id parent;
@property (strong, nonatomic) IBOutlet UIView *viewDatePic;
@property (strong, nonatomic) IBOutlet UIDatePicker *picDate;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UITextField *fnameTxtfield;
@property (strong, nonatomic) IBOutlet UITextField *lnameTxtfield;
@property (strong, nonatomic) IBOutlet UITextField *unameTxtfield;

@property (strong, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UIView *picView;



- (IBAction)onClickGenderBtn:(id)sender;

- (IBAction)onClickGenderDone:(id)sender;

- (IBAction)onClickBtnClose:(id)sender;
- (IBAction)onClickDone:(id)sender;
- (IBAction)onClickSignup:(id)sender;

@end
