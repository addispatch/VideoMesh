//
//  VideoMesh.m
//  VideoMeshiOS
//
//  Created by Christopher Baltzer on 2013-10-29.
//  Copyright (c) 2013 Ad-Dispatch. All rights reserved.
//

#import "VideoMesh.h"

void _setVideo(const char * filename) {
    NSLog(@"Native plugin: %@", [NSString stringWithUTF8String:filename]);
}

void _play() {
}

void _pause() {
}


@implementation VideoMesh

static VideoMesh *sharedInstance = nil;
+(VideoMesh*)sharedInstance {
    if( !sharedInstance )
        sharedInstance = [[VideoMesh alloc] init];
    
    return sharedInstance;
}


@end
