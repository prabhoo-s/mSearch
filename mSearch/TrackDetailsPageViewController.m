//
//  TrackDetailsPageViewController.m
//  mSearch
//
//  Created by Prabhu.S on 21/02/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "TrackDetailsPageViewController.h"

#import "common.h"
#import "TrackDetailsTableViewController.h"

@interface TrackDetailsPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, assign) NSUInteger currentTaskIndex;

@end

@implementation TrackDetailsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Lyrics";
    [self createPageViewController];
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor lightTextColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [UIColor lightTextColor]];
    [[UIPageControl appearance] setBackgroundColor: APP_THEME_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createPageViewController {
    UIPageViewController *pageController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"ID_PAGE_VC"];
    pageController.dataSource = self;
    pageController.delegate = self;
    
    if ([self.trackItems count]) {
        NSArray *startingViewControllers = @[[self itemControllerForIndex: self.selecteTaskIndex]];
        [pageController setViewControllers: startingViewControllers
                                 direction: UIPageViewControllerNavigationDirectionForward
                                  animated: NO
                                completion: nil];
    }
    
    self.pageViewController = pageController;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController {
    TrackDetailsTableViewController *itemController = (TrackDetailsTableViewController *) viewController;
    
    if (itemController.itemIndex > 0) {
        return [self itemControllerForIndex: itemController.itemIndex - 1];
    }

    return nil;
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *) viewController {
    TrackDetailsTableViewController *itemController = (TrackDetailsTableViewController *) viewController;
    
    if (itemController.itemIndex + 1 < [self.trackItems count]) {
        return [self itemControllerForIndex: itemController.itemIndex + 1];
    }

    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentTaskIndex =
            ((UIViewController *)self.pageViewController.viewControllers.firstObject).view.tag;
    }
}

#pragma mark - Page Indicator

- (NSInteger) presentationCountForPageViewController: (UIPageViewController *) pageViewController {
    //simplly to denote pages
    return 3;
}

- (NSInteger) presentationIndexForPageViewController: (UIPageViewController *) pageViewController {
    return 0;
}

#pragma mark - Private methods

- (TrackDetailsTableViewController *)itemControllerForIndex: (NSUInteger)itemIndex {
    if (itemIndex < [self.trackItems count]) {
        TrackDetailsTableViewController *pageItemController =
            [self.storyboard instantiateViewControllerWithIdentifier: @"ID_TRACK_DETAIL_VC"];
        pageItemController.itemIndex = itemIndex;
        
        Track *track = [self.trackItems objectAtIndex:itemIndex];
        pageItemController.trackItem = track;
        pageItemController.view.tag = itemIndex;

        return pageItemController;
    }
    
    return nil;
}

@end
