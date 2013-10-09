//
//  REFrostedContainerViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 10/8/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REFrostedContainerViewController.h"
#import "UIImage+REFrostedViewController.h"
#import "UIView+REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"

@interface REFrostedContainerViewController ()

@property (strong, readwrite, nonatomic) UIImageView *backgroundImageView;
@property (strong, readwrite, nonatomic) UIView *backgroundView;
@property (strong, readwrite, nonatomic) UIView *containerView;
@property (assign, readwrite, nonatomic) CGPoint containerOrigin;

@end

@interface REFrostedViewController ()

@property (assign, readwrite, nonatomic) BOOL visible;

@end

@implementation REFrostedContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.0f;
    [self.view addSubview:self.backgroundView];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, self.view.frame.size.height)];
    self.containerView.clipsToBounds = YES;
    [self.view addSubview:self.containerView];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.image = self.screenshotImage;
    [self.containerView addSubview:self.backgroundImageView];
    
    [self addChildViewController:self.frostedViewController.menuViewController];
    self.frostedViewController.menuViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.frostedViewController.menuViewController.view];
    [self.frostedViewController.menuViewController didMoveToParentViewController:self];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.backgroundView addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.frostedViewController.menuViewController beginAppearanceTransition:YES animated:animated];
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionLeft) {
        [self setContainerFrame:CGRectMake(- self.frostedViewController.minimumMenuViewSize.width, 0, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionRight) {
        [self setContainerFrame:CGRectMake(self.view.frame.size.width, 0, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionTop) {
        [self setContainerFrame:CGRectMake(0, -self.frostedViewController.minimumMenuViewSize.height, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionBottom) {
        [self setContainerFrame:CGRectMake(0, self.view.frame.size.height, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
    }
    
    if (self.animateApperance)
        [self show];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.frostedViewController.menuViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.frostedViewController.menuViewController beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.frostedViewController.menuViewController endAppearanceTransition];
}

- (void)setContainerFrame:(CGRect)frame
{
    self.containerView.frame = frame;
    self.backgroundImageView.frame = CGRectMake(- frame.origin.x, - frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)show
{
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionLeft) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, 0, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            self.backgroundView.alpha = 0.3f;
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionRight) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.view.frame.size.width - self.frostedViewController.minimumMenuViewSize.width, 0, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            self.backgroundView.alpha = 0.3f;
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionTop) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, 0, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            self.backgroundView.alpha = 0.3f;
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionBottom) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, self.view.frame.size.height - self.frostedViewController.minimumMenuViewSize.height, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            self.backgroundView.alpha = 0.3f;
        }];
    }
}

- (void)hide
{
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionLeft) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(- self.frostedViewController.minimumMenuViewSize.width, 0, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionRight) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.view.frame.size.width, 0, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionTop) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, -self.frostedViewController.minimumMenuViewSize.height, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionBottom) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, self.view.frame.size.height, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
        }];
    }
}

- (void)refreshBackgroundImage
{
    self.backgroundImageView.image = self.screenshotImage;
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer
{
    [self hide];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.containerOrigin = self.containerView.frame.origin;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.containerView.frame;
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionLeft) {
            frame.origin.x = self.containerOrigin.x + point.x;
            if (frame.origin.x > 0) {
                frame.origin.x = 0;
                
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.size.width = self.frostedViewController.minimumMenuViewSize.width + self.containerOrigin.x + point.x;
                    if (frame.size.width > self.view.frame.size.width)
                        frame.size.width = self.view.frame.size.width;
                }
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionRight) {
            frame.origin.x = self.containerOrigin.x + point.x;
            if (frame.origin.x < self.view.frame.size.width - self.frostedViewController.minimumMenuViewSize.width) {
                frame.origin.x = self.view.frame.size.width - self.frostedViewController.minimumMenuViewSize.width;
            
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.origin.x = self.containerOrigin.x + point.x;
                    if (frame.origin.x < 0)
                        frame.origin.x = 0;
                    frame.size.width = self.view.frame.size.width - frame.origin.x;
                }
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionTop) {
            frame.origin.y = self.containerOrigin.y + point.y;
            if (frame.origin.y > 0) {
                frame.origin.y = 0;
            
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.size.height = self.frostedViewController.minimumMenuViewSize.height + self.containerOrigin.y + point.y;
                    if (frame.size.height > self.view.frame.size.height)
                        frame.size.height = self.view.frame.size.height;
                }
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionBottom) {
            frame.origin.y = self.containerOrigin.y + point.y;
            if (frame.origin.y < self.view.frame.size.height - self.frostedViewController.minimumMenuViewSize.height) {
                frame.origin.y = self.view.frame.size.height - self.frostedViewController.minimumMenuViewSize.height;
            
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.origin.y = self.containerOrigin.y + point.y;
                    if (frame.origin.y < 0)
                        frame.origin.y = 0;
                    frame.size.height = self.view.frame.size.height - frame.origin.y;
                }
            }
        }
        
        [self setContainerFrame:frame];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionLeft) {
            if ([recognizer velocityInView:self.view].x < 0) {
                [self hide];
            } else {
                [self show];
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionRight) {
            if ([recognizer velocityInView:self.view].x < 0) {
                [self show];
            } else {
                [self hide];
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionTop) {
            if ([recognizer velocityInView:self.view].y < 0) {
                [self hide];
            } else {
                [self show];
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionBottom) {
            if ([recognizer velocityInView:self.view].y < 0) {
                [self show];
            } else {
                [self hide];
            }
        }
    }
}

@end
