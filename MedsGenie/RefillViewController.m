//
//  RefillViewController.m
//  medsgenie
//
//  Created by Wojciech Chojnacki on 13.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import "RefillViewController.h"
#import <PayPal-iOS-SDK/PayPalMobile.h>

@interface RefillViewController () {
    NSInteger _amount;
}
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@property (weak, nonatomic) IBOutlet UITableViewCell *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UITableViewCell *priceCell;

@end

@implementation RefillViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    _amount = 5;
    _stepper.value = _amount;
    [self updateLabels];
    
    
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    _payPalConfiguration.acceptCreditCards = NO;
    _payPalConfiguration.languageOrLocale = @"en";
    _payPalConfiguration.merchantName = @"Acme Pharmacy ";
    _payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.omega.supreme.example/privacy"];
    _payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.omega.supreme.example/user_agreement"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)stepstep:(id)sender {
    if(_stepper.value>=1) {
    }else {
        _stepper.value = 1;
    }
    _amount = _stepper.value;
    [self updateLabels];
    
}

-(void)updateLabels {
    _stepper.value = _amount;
    _amountLabel.text = [NSString stringWithFormat:@"%i", _amount];
    
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:@"0.25"];
    price = [price decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[@(_amount) decimalValue]]];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setCurrencyCode:@"USD"];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    self.priceCell.textLabel.text = [numberFormatter stringFromNumber:price];
}

- (IBAction)buy:(id)sender {
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:@"0.25"];
    price = [price decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[@(_amount) decimalValue]]];
    PayPalItem *item1 = [PayPalItem itemWithName:_item.name
                                    withQuantity:2
                                       withPrice:price
                                    withCurrency:@"USD"
                                         withSku:nil];
}
@end
