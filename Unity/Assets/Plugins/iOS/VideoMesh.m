//
//  VideoMesh.m
//  VideoMeshiOS
//
//  Created by Christopher Baltzer on 2013-10-29.
//  Copyright (c) 2013 Ad-Dispatch. All rights reserved.
//

#import "VideoMesh.h"

void _update() {
    [[VideoMesh sharedInstance] update];
}

void _setLogCallback(callbackFunc cb) {
    [[VideoMesh sharedInstance] setLogCallback:cb];
}

void _setTexture(GLuint texID) {
    [[VideoMesh sharedInstance] setTexture:texID];
}

void _setVideo(const char * filename) {
    [[VideoMesh sharedInstance] setVideo:[NSString stringWithUTF8String:filename]];
}

void _play() {
    [[VideoMesh sharedInstance].videoPlayer play];
}

void _pause() {
    [[VideoMesh sharedInstance].videoPlayer pause];
}


@implementation VideoMesh

@synthesize texID, videoOutput, videoPlayer;

@synthesize logCallback;

static VideoMesh *sharedInstance = nil;
+(VideoMesh*)sharedInstance {
    if( !sharedInstance )
        sharedInstance = [[VideoMesh alloc] init];
    
    return sharedInstance;
}


-(id)init {
    if (self = [super init]) {
    }
    return self;
}


-(void)setTexture:(GLuint)tex {
    self.texID = tex;
}


-(void)unityLog:(NSString*)message {
    NSLog(@"%@", message);
    if (self.logCallback != NULL) {
        self.logCallback([message UTF8String]);
    }
}


-(void)setVideo:(NSString*)filePath {
    NSLog(@"Attempting to load %@", filePath);
    [self unityLog:filePath];
    
    NSURL *file = [NSURL URLWithString:filePath];
    
    if (self.videoPlayer != nil) {
        [self.videoPlayer release];
        self.videoPlayer = nil;
    }
    
    self.videoPlayer = [[AVPlayer alloc] initWithURL:file];

    if (self.videoPlayer != nil) {
        [self unityLog:@"Player initialized"];
    } else {
        [self unityLog:@"Error initializing"];
    }
    
    if (self.videoOutput != nil) {
        [self.videoOutput release];
        self.videoOutput = nil;
    }

    NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    self.videoOutput = [[AVPlayerItemVideoOutput alloc]
                                       initWithPixelBufferAttributes:pixBuffAttributes];
    
    [self.videoPlayer.currentItem addOutput:self.videoOutput];
}


-(void)update {
    // per frame eek
    CMTime outputItemTime = self.videoPlayer.currentTime;
    
    if ([self.videoOutput hasNewPixelBufferForItemTime:outputItemTime]) {
        CVPixelBufferRef buffer = [self.videoOutput copyPixelBufferForItemTime:outputItemTime itemTimeForDisplay:nil];
        
        // Lock the image buffer
        CVPixelBufferLockBaseAddress(buffer, 0);
        
        // Get information of the image
        size_t width = CVPixelBufferGetWidth(buffer);
        size_t height = CVPixelBufferGetHeight(buffer);
        
        // Fill the texture
        glBindTexture(GL_TEXTURE_2D, self.texID);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_BGRA, GL_UNSIGNED_BYTE, (uint8_t *)CVPixelBufferGetBaseAddress(buffer));
        

        
        // Unlock the image buffer
        CVPixelBufferUnlockBaseAddress(buffer, 0);
        CVBufferRelease(buffer);
        
        glFinish();
    }
}

@end
