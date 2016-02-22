//
//  SearchViewControllerTests.m
//  mSearch
//
//  Created by Prabhu.S on 22/02/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SearchScreenTableViewController.h"
#import "SearchItemTableViewCell.h"

@interface SearchViewControllerTests : XCTestCase {
    SearchScreenTableViewController *searchScreenTVC;
    NSIndexPath *indexPath;
}
@end

@implementation SearchViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    searchScreenTVC = [storyboard instantiateViewControllerWithIdentifier:@"ID_SEARCH_SCREEN"];
    [searchScreenTVC view];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    searchScreenTVC=nil;
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
    XCTAssertNotNil([searchScreenTVC view], @"View not initiated properly");
}

#pragma mark - IBOutlet connection

- (void)testThatViewHasTableView {
    XCTAssertNotNil([searchScreenTVC tableView], @"SearchScreenTableViewController:Tableview not initiated");
}

- (void)testThatViewHasSearchbar {
    XCTAssertNotNil([searchScreenTVC searchbar], @"SearchScreenTableViewController:UISearchbar not initiated");
}

#pragma mark - UITableView

- (void)testThatViewConformsToUITableViewDataSource {
    XCTAssertTrue([searchScreenTVC conformsToProtocol:@protocol(UITableViewDataSource) ], @"SearchScreenTableViewController does not conform to UITableView datasource protocol");
}

- (void)testThatViewConformsToUITableViewDelegate {
    XCTAssertTrue([searchScreenTVC conformsToProtocol:@protocol(UITableViewDelegate) ], @"SearchScreenTableViewController does not conform to UITableView delegate protocol");
}

- (void)testThatTableViewHasDataSource {
    XCTAssertNotNil([[searchScreenTVC tableView] dataSource], @"Table datasource cannot be nil");
}

- (void)testTableViewIsConnectedToDelegate {
    XCTAssertNotNil([[searchScreenTVC tableView] delegate], @"Table delegate cannot be nil");
}

- (void)testContactTableViewHeightForRowAtIndexPath {

    CGFloat actualHeight = [searchScreenTVC tableView:searchScreenTVC.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqual([SearchItemTableViewCell heightForCell], actualHeight, @"SearchScreenTableViewController cell height value is incorrect");
}

- (void)testTableViewCellCreateCellsWithReuseIdentifier {
    XCTAssertTrue([[SearchItemTableViewCell reuseIdentifier] isEqualToString:@"ID_TRACK_CELL"], @"SearchScreenTableViewController does not create reusable cells");
}

@end
