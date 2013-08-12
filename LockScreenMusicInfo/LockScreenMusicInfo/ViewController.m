//
//  ViewController.m
//  LockScreenMusicInfo
//
//  Created by TonyKong on 13-8-12.
//  Copyright (c) 2013年 Tony. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[AVAudioSession sharedInstance] setDelegate:self];
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"set AVAudioSessionCategoryPlayback failed:%@", error);
        return;
    }
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

    //百度MP3链接
    NSURL *url = [NSURL URLWithString:@"http://music.baidu.com/data/music/file?link=http://zhangmenshiting.baidu.com/data2/music/65595180/65545701248400128.mp3?xcode=30c7b4ef77e0a05a5f5f82a8ec8d150a2bfbe173b0caad11"];
    _player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    _player.shouldAutoplay = NO;
    _player.controlStyle = MPMovieControlStyleEmbedded;
    _player.view.hidden = YES;
    [_player prepareToPlay];


    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(60, 100, 200, 200);
    [button setTitle:@"play" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)buttonPress:(UIButton*)sender
{
    [_player play];
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"AlbumArt.jpg"]];
        
        [songInfo setObject:@"Audio Title" forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:@"Audio Author" forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    } else {
        NSLog(@"MPNowPlayingInfoCenter class is not found");
    }
}

//响应远程音乐播放控制消息
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (_player.playbackState == MPMoviePlaybackStatePlaying) {
                    [_player pause];
                } else {
                    [_player play];
                }
                NSLog(@"RemoteControlEvents: pause");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"RemoteControlEvents: playModeNext");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"RemoteControlEvents: playPrev");
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
