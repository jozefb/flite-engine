//
//  FliteEngine.m
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

#import "FliteEngine.h"
#import "flite.h"

cst_voice *register_cmu_us_kal();
cst_wave *sound;
cst_voice *voice;

@implementation FliteEngine

@synthesize durationStretch, variance, pitch, volume;
@synthesize tempFilePath;
@synthesize delegate;

-(id)init {
	if (self = [super init]) {
		flite_init();
		voice = register_cmu_us_kal();
		self.durationStretch = 1.1;
		self.variance = 11.0;
		self.pitch = 95.0;
	}
		
    return self;
}


-(void)setVoicePitch:(float)aPitch variance:(float)aVariance speed:(float)speed {
	feat_set_float(voice->features,"int_f0_target_mean", aPitch);
	feat_set_float(voice->features,"int_f0_target_stddev",aVariance);
	feat_set_float(voice->features,"duration_stretch", speed);
}

- (void)setDurationStretch:(float)stretch {
	durationStretch = stretch;
	feat_set_float(voice->features,"duration_stretch", stretch);
}

- (void)setPitch:(float)value {
	pitch = value;
	feat_set_float(voice->features,"int_f0_target_mean", value);
}


- (void)setVariance:(float)value {
	variance = value;
	feat_set_float(voice->features,"int_f0_target_stddev", value);
}

- (BOOL)isPlaying {
	return [player isPlaying];
}

- (NSString*)tempFilePath {
	if (tempFilePath == nil) {
		NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *recordingDirectory = [filePaths objectAtIndex: 0];
		
		tempFilePath = [[NSString stringWithFormat: @"%@/%s", recordingDirectory, "temp.wav"] retain];
	}
	
	return tempFilePath;
}

-(void)speak:(NSString *)text {
	if ([player isPlaying]) {
		[self.delegate fliteEngineDidFinishSpeaking:self successfully:NO];
		return;
	}
	
	NSMutableString *cleanString = [NSMutableString stringWithString:@""];
	if([text length] > 1) {
		int x = 0;
		while (x < [text length]) {
			unichar ch = [text characterAtIndex:x];
			[cleanString appendFormat:@"%c", ch];
			x++;
		}
	}
	
	if(cleanString == nil) {	// string is empty
		cleanString = [NSMutableString stringWithString:@""];
	}
	sound = flite_text_to_wave([cleanString UTF8String], voice);
	// save wave to disk
	char *path;	
	path = (char*)[self.tempFilePath UTF8String];
	cst_wave_save_riff(sound, path);
	// Play the sound back.
	NSError *error = nil;
	[player release];
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.tempFilePath] error:&error];
	player.volume = self.volume;
	if (error) {
		[self.delegate fliteEngineErrorDidOccur:self error:error];
		return;
	}
	
	[player setDelegate:self];
	[player prepareToPlay];
	[self.delegate fliteEngineDidStartSpeaking:self successfully:YES];
	[player play];
	// Remove file
	[[NSFileManager defaultManager] removeItemAtPath:self.tempFilePath error:nil];
	
}

/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	[self.delegate fliteEngineDidFinishSpeaking:self successfully:flag];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	[self.delegate fliteEngineErrorDidOccur:self error:error];
}

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	[self.delegate fliteEngineBeginInterruption:self];
}

/* audioPlayerEndInterruption: is called when the audio session interruption has ended and this player had been interrupted while playing. 
 The player can be restarted at this point. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	[self.delegate fliteEngineEndInterruption:self];
}

- (void)stop {
	[player stop];
	[player release];
	player = nil;
	[self.delegate fliteEngineDidFinishSpeaking:self successfully:NO];
}

- (void)dealloc {
	[player release];
	[tempFilePath release];
	[super dealloc];
}

@end
