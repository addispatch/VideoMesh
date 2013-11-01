//
//  VideoMesh.h
//  VideoMeshiOS
//
//  Created by Christopher Baltzer on 2013-10-29.
//  Copyright (c) 2013 Ad-Dispatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/OpenGL.h>
#import <AVFoundation/AVFoundation.h>


void _setVideo(const char *);
void _play();
void _pause() ;

@interface VideoMesh : NSObject {
    AVPlayer *videoPlayer;
    AVPlayerItemVideoOutput *videoOutput;
    GLuint texID;
}

@property (nonatomic, retain) AVPlayer *videoPlayer;
@property (nonatomic, retain) AVPlayerItemVideoOutput *videoOutput;
@property (nonatomic, assign) GLuint texID;

+(VideoMesh*)sharedInstance;

-(void)setTexture:(GLuint)tex;
-(void)setVideo:(NSString*)filePath;

-(void)update;

@end
