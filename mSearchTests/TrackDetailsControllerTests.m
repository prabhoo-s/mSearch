//
//  TrackDetailsControllerTests.m
//  mSearch
//
//  Created by Prabhu.S on 23/02/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TrackDetailsTableViewController.h"

@interface TrackDetailsControllerTests : XCTestCase {
    TrackDetailsTableViewController *trackDetailsTVC;
    NSIndexPath *indexPath;
}
@end

@implementation TrackDetailsControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    trackDetailsTVC = [storyboard instantiateViewControllerWithIdentifier:@"ID_TRACK_DETAIL_VC"];
    [trackDetailsTVC view];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    trackDetailsTVC=nil;
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - View loading

- (void)testThatViewLoads {
    XCTAssertNotNil([trackDetailsTVC view], @"View not initiated properly");
}

#pragma mark - IBOutlet connection

- (void)testThatViewHasTableView {
    XCTAssertNotNil([trackDetailsTVC tableView], @"TrackDetailsTableViewController:Tableview not initiated");
}

#pragma mark - UITableView

- (void)testThatViewConformsToUITableViewDataSource {
    XCTAssertTrue([trackDetailsTVC conformsToProtocol:@protocol(UITableViewDataSource) ], @"TrackDetailsTableViewController does not conform to UITableView datasource protocol");
}

- (void)testThatViewConformsToUITableViewDelegate {
    XCTAssertTrue([trackDetailsTVC conformsToProtocol:@protocol(UITableViewDelegate) ], @"TrackDetailsTableViewController does not conform to UITableView delegate protocol");
}

- (void)testThatTableViewHasDataSource {
    XCTAssertNotNil([[trackDetailsTVC tableView] dataSource], @"Table datasource cannot be nil");
}

- (void)testTableViewIsConnectedToDelegate {
    XCTAssertNotNil([[trackDetailsTVC tableView] delegate], @"Table delegate cannot be nil");
}

@end
