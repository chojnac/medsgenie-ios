//
//  StorageViewController.m
//  MedsGenie
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import "StorageViewController.h"
#import "StorageDatasource.h"

@interface StorageViewController ()
@property (nonatomic, weak) StorageDatasource *storageDatasource;
@end

@implementation StorageViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.storageDatasource = [StorageDatasource sharedDatasource];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.storageDatasource numerOfTrays];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    StorageItem *item = [self.storageDatasource itemAtIndex:indexPath.section];
    if(item.pillsCount==0) {
        cell.textLabel.text = @"empty";
        cell.detailTextLabel.text = @"";
    }else {
        cell.textLabel.text = [NSString stringWithFormat:@"%i",item.pillsCount];
        cell.detailTextLabel.text = item.name;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    StorageItem *item = [self.storageDatasource itemAtIndex:section];
    return item.tray.name;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    StorageItem *item = [self.storageDatasource itemAtIndex:indexPath.section];
    if([segue.destinationViewController respondsToSelector:@selector(setTray:)]) {
        [segue.destinationViewController setTray:item.tray];
    }
}
@end
