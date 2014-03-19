//
//  ILETableViewController.m
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/18/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "ILERemoteImageTableViewCell.h"
#import "ILETableViewController.h"

@interface ILETableViewController ()
{
@private
    NSArray *_corgis;
}

@end

@implementation ILETableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *corgiStrings = @[@"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr03/5/11/enhanced-buzz-22866-1386260133-20.jpg",
                              @"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr07/5/11/enhanced-buzz-11700-1386260284-0.jpg",
                              @"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr05/5/11/enhanced-buzz-2467-1386261470-5.jpg",
                              @"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr05/5/11/enhanced-buzz-3544-1386261696-1.jpg",
                              @"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr02/5/11/enhanced-buzz-18047-1386261696-2.jpg",
                              @"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr07/5/12/enhanced-buzz-20103-1386264189-5.jpg",
                              @"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr06/5/11/enhanced-buzz-15360-1386262189-22.jpg",
                              @"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr02/5/14/enhanced-buzz-9031-1386271432-4.jpg",
                              @"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr02/5/16/enhanced-buzz-23452-1386278378-1.jpg",
                              @"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr05/5/14/enhanced-buzz-19728-1386270926-14.jpg"];
    
    _corgis = SVMap(corgiStrings, ^id(id object) {
        return [NSURL URLWithString:object];
    });
    
    [self.tableView registerClass:[ILERemoteImageTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([ILERemoteImageTableViewCell class])];
}

#pragma mark - Table View Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _corgis.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ILERemoteImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ILERemoteImageTableViewCell class])
                                                            forIndexPath:indexPath];
    
    cell.remoteImage = [[SVRemoteRetainedScaledImage remoteScaledImageForURL:_corgis[indexPath.item]
                                                           withScale:[UIScreen mainScreen].scale
                                                                size:CGSizeMake(44, 44)] autoload];
    
    return cell;
}

@end
