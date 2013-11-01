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

void _setTexID(GLuint texID) {
    [[VideoMesh sharedInstance] setTexture:texID];
}

void _setVideo(const char * filename) {
    NSLog(@"Native plugin: %@", [NSString stringWithUTF8String:filename]);
}

void _play() {
    [[VideoMesh sharedInstance].videoPlayer play];
}

void _pause() {
    [[VideoMesh sharedInstance].videoPlayer pause];
}


@implementation VideoMesh

@synthesize texID, videoOutput, videoPlayer;

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


-(void)setVideo:(NSString*)filePath {
    
    NSURL *file = [NSURL URLWithString:filePath];
    
    if (self.videoPlayer != nil) {
        [self.videoPlayer release];
        self.videoPlayer = nil;
    }
    
    self.videoPlayer = [[AVPlayer alloc] initWithURL:file];
    
    
    NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
    
    //NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    
    if (self.videoOutput != nil) {
        [self.videoOutput release];
        self.videoOutput = nil;
    }
    
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
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_BGRA_EXT, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(buffer));
        
        // Unlock the image buffer
        CVPixelBufferUnlockBaseAddress(buffer, 0);
        //CFRelease(sampleBuffer);
        CVBufferRelease(buffer);
        
    }
}

@end
