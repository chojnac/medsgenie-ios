//
//  HomeViewController.m
//  MedsGenie
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
#import "RefillViewController.h"

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
        [[StorageDatasource sharedDatasource] updateStockFromDoses:item.doses];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self checkEmptyStock];
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
        UILabel *label2 = (UILabel *)[cell viewWithTag:90];
        ScheduleItem *item = [[ScheduleDatasoure sharedDatasource] itemAtIndex:indexPath.row];
        label.text = item.name;
        label2.text = [NSString stringWithFormat:@"%@ , %i pills",item.when, [item numerOfPills]];
        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    StorageItem *item = [[StorageDatasource sharedDatasource] itemAtIndex:indexPath.row];
    if(item.pillsCount==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ is empty",item.tray.name];
    }else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %i",item.tray.name, item.pillsCount];
    }
    
    UILabel *refillLabel = (UILabel *)[cell viewWithTag:100];
    if(!refillLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 73, 21)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        label.tag = 100;
        label.text = @"Buy refill";
        label.center =  CGPointMake(CGRectGetMidX(cell.bounds), CGRectGetMidY(cell.bounds));
        [cell.contentView addSubview:label];
        refillLabel = label;
    }
    
    if(item.pillsCount<=1) {
        refillLabel.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"";
        cell.backgroundColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }else {
        refillLabel.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
    if(indexPath.section!=1) return nil;
   StorageItem *item = [[StorageDatasource sharedDatasource] itemAtIndex:indexPath.row];
    if(item.pillsCount>1) return nil;
    return indexPath;
}

-(void)checkEmptyStock {
    NSInteger j = [[StorageDatasource sharedDatasource] numerOfTrays];
    for(int i=0;i<j;i++ ) {
        StorageItem *item  = [[StorageDatasource sharedDatasource] itemAtIndex:i];
        if(item.pillsCount<=1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your pills are running low. Would you like to buy a refill?" delegate:self
        cancelButtonTitle:@"No" otherButtonTitles:@"Buy", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag!=100) return;
    [SVProgressHUD showWithStatus:@"Your order is processing..."];
    [self performSelector:@selector(closeBuying) withObject:nil afterDelay:4];
}

-(void)closeBuying {
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your pills are on the way!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = sender;
        if(![cell.reuseIdentifier isEqualToString:@"Cell2"]) return;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        StorageItem *item = [[StorageDatasource sharedDatasource] itemAtIndex:indexPath.row];
        UINavigationController *nc = segue.destinationViewController;
        RefillViewController *vc = (RefillViewController *)nc.topViewController;
        vc.item = item;
    }
}
@end
