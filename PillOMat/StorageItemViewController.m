//
//  StorageItemViewController.m
//  PillOMat
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import "StorageItemViewController.h"
#import "StorageDatasource.h"

@interface StorageItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation StorageItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    StorageItem *item = [[StorageDatasource sharedDatasource] itemForTray:self.tray];
    [self updateWithStorageItem:item];
    self.stepper.value = item.pillsCount;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

-(void)updateWithStorageItem:(StorageItem *)item {
    self.name.text = item.name;
    self.amountField.text = [NSString stringWithFormat:@"%i", item.pillsCount];
}

- (IBAction)save:(id)sender {
    StorageItem *item = [[StorageDatasource sharedDatasource] itemForTray:self.tray];
    item.name = _name.text;
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)nameChanged:(id)sender {
    StorageItem *item = [[StorageDatasource sharedDatasource] itemForTray:self.tray];
    item.name = _name.text;
}

- (IBAction)step:(id)sender {
    StorageItem *item = [[StorageDatasource sharedDatasource] itemForTray:self.tray];
    item.pillsCount = self.stepper.value;
    [self updateWithStorageItem:item];
}

@end
