//
//  HomeViewController.m
//  PillOMat
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import "HomeViewController.h"
#import "ScheduleDatasoure.h"
#import "StorageDatasource.h"
#import "UIView+TableViewCell.h"
#import "APIManager.h"
#import <SVProgressHUD.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (IBAction)giveMe:(id)sender {
    UIButton *button = sender;
    button.enabled = NO;
    UITableViewCell *cell = (UITableViewCell *)[button findSuperViewWithClass:[UITableViewCell class]];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if(indexPath.section!=0) return;

    ScheduleItem *item = [[ScheduleDatasoure sharedDatasource] itemAtIndex:indexPath.row];
    NSMutableArray *pillsForTrays = [NSMutableArray array];
    for(ScheduleItemDose *dose in item.doses) {
        for(int i=0;i<dose.pillsCount;i++) {
            [pillsForTrays addObject:@(dose.tray.number)];
        }
    }
    
    
    APIManager *api = [APIManager new];
    [SVProgressHUD showWithStatus:@"Dispensing"];
    [api giveMeThePills:pillsForTrays success:^{
        [SVProgressHUD dismiss];
        button.enabled = YES;
        [[[UIAlertView alloc] initWithTitle:nil message:@"Take your pills!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [[StorageDatasource sharedDatasource] updateStockFromDoses:item.doses];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failuer:^(NSString *errorMessage, NSError *error) {
        [SVProgressHUD dismiss];
        button.enabled = YES;
        [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage ? errorMessage : error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0) return [[ScheduleDatasoure sharedDatasource] numerOfItems];
    return [[StorageDatasource sharedDatasource] numerOfTrays];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:10];
        ScheduleItem *item = [[ScheduleDatasoure sharedDatasource] itemAtIndex:indexPath.row];
        label.text = item.name;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ , %i pills",item.when, [item numerOfPills]];
        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    StorageItem *item = [[StorageDatasource sharedDatasource] itemAtIndex:indexPath.row];
    if(item.pillsCount==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ is empty",item.tray.name];
    }else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %i",item.tray.name, item.pillsCount];
    }
    
    if(item.pillsCount<=1) {
        cell.detailTextLabel.text = @"";
        cell.backgroundColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }else {        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    if(item.name) {
        cell.detailTextLabel.text = item.name;
    }else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section==0) return @"Schedule";
    else return @"Stock";
}

@end
