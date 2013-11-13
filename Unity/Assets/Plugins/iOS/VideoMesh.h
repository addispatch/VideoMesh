//
//  VideoMesh.h
//  VideoMeshiOS
//
//  Created by Christopher Baltzer on 2013-10-29.
//  Copyright (c) 2013 Ad-Dispatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#if TARGET_OS_MAC
#import <OpenGL/gl.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreImage.h>
#endif

typedef void (*callbackFunc)(const char *);
void _setLogCallback(callbackFunc);
void _update();
void _setTexture(GLuint);
void _setVideo(const char *);
void _play();
void _pause() ;

@interface VideoMesh : NSObject {
    AVPlayer *videoPlayer;
    AVPlayerItemVideoOutput *videoOutput;
    GLuint texID;
    
    callbackFunc logCallback;
}

@property (nonatomic, retain) AVPlayer *videoPlayer;
@property (nonatomic, retain) AVPlayerItemVideoOutput *videoOutput;
@property (nonatomic, assign) GLuint texID;

@property callbackFunc logCallback;

+(VideoMesh*)sharedInstance;

-(void)setTexture:(GLuint)tex;
-(void)setVideo:(NSString*)filePath;

-(void)update;

@end
