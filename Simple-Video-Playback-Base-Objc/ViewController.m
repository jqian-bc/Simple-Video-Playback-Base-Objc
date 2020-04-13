//
//  ViewController.m
//  Simple-Video-Playback-Base-Objc
//
//  Created by Jimmy Qian on 14/4/20.
//  Copyright © 2020 Brightcove. All rights reserved.
//

#import "ViewController.h"

// ** Customize these values with your own account information **
static NSString * const kViewControllerPlaybackServicePolicyKey = @"BCpkADawqM2QbN06oEXn9FXLGjB1fOWo-9sepM-38TtbKW25yDicL7_jxd0gJuyw-tKT_WNu4JpymXOc7ui7Xig4q6Ri9D8ryfjmDO4GK8CipXY46JXgDZC_uvU9CG19SLzTYN8B8IMRLydE";
static NSString * const kViewControllerAccountID = @"6143758058001";
static NSString * const kViewControllerVideoID = @"6144778359001";

@interface ViewController () <BCOVPlaybackControllerDelegate>

@property (nonatomic, strong) BCOVPlaybackService *playbackService;
@property (nonatomic, strong) id<BCOVPlaybackController> playbackController;
@property (nonatomic) BCOVPUIPlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIView *videoContainer;

@end

@implementation ViewController
#pragma mark Setup Methods

- (instancetype)initWithCoder:(NSCoder *)coder
{
self = [super initWithCoder:coder];
if (self)
{
        [self setup];
}
return self;
}

- (void)setup
{
_playbackController = [BCOVPlayerSDKManager.sharedManager createPlaybackController];

_playbackController.analytics.account = kViewControllerAccountID; // Optional

_playbackController.delegate = self;
_playbackController.autoAdvance = YES;
_playbackController.autoPlay = YES;

_playbackService = [[BCOVPlaybackService alloc] initWithAccountId:kViewControllerAccountID policyKey:kViewControllerPlaybackServicePolicyKey];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set up our player view. Create with a standard VOD layout.
    BCOVPUIPlayerView *playerView = [[BCOVPUIPlayerView alloc] initWithPlaybackController:self.playbackController options:nil controlsView:[BCOVPUIBasicControlView basicControlViewWithVODLayout] ];

    [_videoContainer addSubview:playerView];
    playerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [playerView.topAnchor constraintEqualToAnchor:_videoContainer.topAnchor],
        [playerView.rightAnchor constraintEqualToAnchor:_videoContainer.rightAnchor],
        [playerView.leftAnchor constraintEqualToAnchor:_videoContainer.leftAnchor],
        [playerView.bottomAnchor constraintEqualToAnchor:_videoContainer.bottomAnchor],
    ]];
    _playerView = playerView;

    // Associate the playerView with the playback controller.
    _playerView.playbackController = _playbackController;

    [self requestContentFromPlaybackService];
}

- (void)requestContentFromPlaybackService
{
[self.playbackService findVideoWithVideoID:kViewControllerVideoID parameters:nil completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {

    if (video)
    {
        [self.playbackController setVideos:@[ video ]];
    }
    else
    {
        NSLog(@"ViewController Debug - Error retrieving video: `%@`", error);
    }

}];
}

@end
