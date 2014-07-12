//
//  SchedulerItemTableViewController.m
//  MedsGenie
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import "SchedulerItemTableViewController.h"
#import "ScheduleDatasoure.h"
#import "StorageDatasource.h"
#import "APIManager.h"
#import <SVProgressHUD.h>

@interface SchedulerItemTableViewController ()

@end

@implementation SchedulerItemTableViewController


-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.item.name;
    
}
- (IBAction)giveMe:(id)sender {
    APIManager *api = [APIManager new];
    [SVProgressHUD showWithStatus:@"Dispensing"];
    [api giveMeThePills:@[@1,@2] success:^{
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:nil message:@"Take your pills!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    } failuer:^(NSString *errorMessage, NSError *error) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage ? errorMessage : error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }];
}
- (IBAction)amountStep:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[StorageDatasource sharedDatasource] numerOfTrays]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        cell.textLabel.text = self.item.when;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    Tray *tray = [[StorageDatasource sharedDatasource] trayAtIndex:indexPath.section-1];
    UILabel *amount = (UILabel *)[cell.contentView viewWithTag:10];
    __block ScheduleItemDose *dose = nil;
    [self.item.doses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ScheduleItemDose *d = obj;
        if([d.tray isEqual:tray]) {
            dose = d;
            *stop = YES;
        }
    }];
    amount.text = [NSString stringWithFormat:@"%i",dose.pillsCount];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section==0) {
        return @"When";
    }
    
    Tray *tray = [[StorageDatasource sharedDatasource] trayAtIndex:section-1];
    StorageItem *storage = [[StorageDatasource sharedDatasource] itemForTray:tray];
    return [NSString stringWithFormat:@"%@: %@", tray.name, storage.name];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
