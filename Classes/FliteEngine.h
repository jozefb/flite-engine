//
//  FliteEngine.h
//  Flite
//
//  Created by Ing. Jozef Bozek on 30.3.2010.
//	Copyright © 2010 bring-it-together s.r.o.. All Rights Reserved.
// 
//	Redistribution and use in source and binary forms, with or without 
//	modification, are permitted provided that the following conditions are met:
//
//	1. Redistributions of source code must retain the above copyright notice, this 
//	   list of conditions and the following disclaimer.
//
//	2. Redistributions in binary form must reproduce the above copyright notice, 
//	   this list of conditions and the following disclaimer in the documentation 
//	   and/or other materials provided with the distribution.
//
//	3. Neither the name of the author nor the names of its contributors may be used
//	   to endorse or promote products derived from this software without specific
//	   prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY BRING-IT-TOGETHER S.R.O. "AS IS"
//	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
//	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVAudioPlayer;
@protocol FliteEngineDelegate;


@interface FliteEngine : NSObject <AVAudioPlayerDelegate> {

@private
	float durationStretch;
	float pitch;
	float variance;
	float volume;
	NSString * tempFilePath;
	AVAudioPlayer * player;
	id<FliteEngineDelegate> delegate;
}

@property (nonatomic, assign) float durationStretch;
@property (nonatomic, assign) float pitch;
@property (nonatomic, assign) float variance;
@property (nonatomic, readonly) NSString * tempFilePath;
@property (nonatomic, assign) id<FliteEngineDelegate> delegate;
@property(readonly, getter=isPlaying) BOOL playing;
@property (nonatomic, assign) float volume;

- (void)speak:(NSString *)text;

- (void)stop;

@end

@protocol FliteEngineDelegate

- (void)fliteEngineDidStartSpeaking:(FliteEngine*)engine successfully:(BOOL)flag;

- (void)fliteEngineDidFinishSpeaking:(FliteEngine*)engine successfully:(BOOL)flag;

- (void)fliteEngineErrorDidOccur:(FliteEngine*)engine error:(NSError *)error;

- (void)fliteEngineBeginInterruption:(FliteEngine*)engine;

- (void)fliteEngineEndInterruption:(FliteEngine*)engine;

@end

