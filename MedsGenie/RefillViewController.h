//
//  RefillViewController.h
//  medsgenie
//
//  Created by Wojciech Chojnacki on 13.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorageItem.h"

@interface RefillViewController : UITableViewController
@property (nonatomic, strong) StorageItem *item;
@end
