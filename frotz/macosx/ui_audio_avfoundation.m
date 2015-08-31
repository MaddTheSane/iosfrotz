/*
 * ui_audio_coreaudio.c - OS X interface, sound support
 *
 * This file is part of Frotz.
 *
 * Frotz is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Frotz is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */

#include "iosfrotz.h"
#if !TARGET_OS_IPHONE
#import <Cocoa/Cocoa.h>
#else
#import <Foundation/Foundation.h>
#endif
#import <AVFoundation/AVFoundation.h>

// Just port the current sound behavior from OSS
#ifndef EMULATE_OSS_SOUND_BEHAVIOR
#define EMULATE_OSS_SOUND_BEHAVIOR 1
#endif

/* Buffer used to store sample data */
//static int current_num;
#if defined (EMULATE_OSS_SOUND_BEHAVIOR) && EMULATE_OSS_SOUND_BEHAVIOR
static AVAudioPlayer *currentSample;
#else
static __weak AVAudioPlayer *currentSample;
static NSMutableDictionary<NSNumber*, AVAudioPlayer*> *samples;
#endif

/**
 * os_beep
 *
 * Play a beep sound. Ideally, the sound should be high- (number == 1)
 * or low-pitched (number == 2).
 *
 */
void os_beep (int number)
{
    // NSBeep is OS X only.
    // And is in AppKit.
    // TODO: additional tone support
#if !TARGET_OS_IPHONE
    NSBeep();
#endif
}/* os_beep */

/**
 * os_prepare_sample
 *
 * Load the sample from the disk.
 *
 */
void os_prepare_sample (int number) {
    @autoreleasepool {
#if !(defined(EMULATE_OSS_SOUND_BEHAVIOR) && EMULATE_OSS_SOUND_BEHAVIOR)
        if (samples[@(number)]) {
            currentSample = samples[@(number)];
            return;
        }
#endif
        NSFileManager *fm = [NSFileManager defaultManager];
        const char *basename, *dotpos;
        size_t namelen;
        currentSample = nil;
        AVAudioPlayer *loadedSample;
        
        basename = strrchr(story_name, '/');
        if (basename) {
            basename++;
        } else {
            basename = story_name;
        }
        dotpos = strrchr(basename, '.');
        namelen = (dotpos ? dotpos - basename : strlen(basename));
        if (namelen > 6) namelen = 6;

        NSString *baseDir = [fm stringWithFileSystemRepresentation:story_name length:(NSUInteger)(basename - story_name)];
        baseDir = [baseDir stringByAppendingPathComponent:@"sound"];
        NSString *nsBaseName = [NSString stringWithFormat:@"%.*s%02d", (int)namelen, basename, number];
        
        //TODO: identify the format, and somehow convert it to something AVAudioPlayer can use if AVAudioPlayer cant play it natively.
        loadedSample = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL fileURLWithPath:nsBaseName] URLByAppendingPathExtension:@"snd"] error:NULL];
        if (!loadedSample) {
            loadedSample = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL fileURLWithPath:nsBaseName] URLByAppendingPathExtension:@"aif"] error:NULL];
        }
        if (!loadedSample) {
            loadedSample = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL fileURLWithPath:nsBaseName] URLByAppendingPathExtension:@"aiff"] error:NULL];
        }
        if (!loadedSample) {
            return;
        }
        [loadedSample prepareToPlay];
#if !(defined(EMULATE_OSS_SOUND_BEHAVIOR) && EMULATE_OSS_SOUND_BEHAVIOR)
        samples[@(number)] = loadedSample;
#endif
        currentSample = loadedSample;
    }
}/* os_prepare_sample */

/**
 * os_start_sample
 *
 * Play the given sample at the given volume (ranging from 1 to 8 and
 * 255 meaning a default volume). The sound is played once or several
 * times in the background (255 meaning forever). In Z-code 3 the
 * repeats value is always 0 and the number of repeats is taken from
 * the sound file itself. The end_of_sound function is called as soon
 * as the sound finishes.
 *
 */
void os_start_sample (int number, int volume, int repeats, zword eos)
{
    @autoreleasepool {
        os_prepare_sample(number);
#if !(defined(EMULATE_OSS_SOUND_BEHAVIOR) && EMULATE_OSS_SOUND_BEHAVIOR)
        currentSample = samples[@(number)];
#endif
        if (currentSample == nil) {
            return;
        }
        float aVol = volume > 8 ? 1 : volume / (float)8;
        currentSample.volume = aVol;
        NSInteger repeatVal = repeats;
        if (repeats == 255) {
            repeatVal = -1; //repeats forever
        } else {
            repeatVal--;
            if (repeatVal < 0) {
                repeatVal = 0;
            }
        }
        currentSample.numberOfLoops = repeatVal;
        
        [currentSample play];
    }
}/* os_start_sample */

/**
 * os_stop_sample
 *
 * Turn off the current sample.
 *
 */
void os_stop_sample (int number)
{
    // Note that, if the base object is nil, Objective C doesn't crash/throw an exception/etc...
    // meaning this is safe code, even if currentSample is nil.
    
#if !(defined(EMULATE_OSS_SOUND_BEHAVIOR) && EMULATE_OSS_SOUND_BEHAVIOR)
    // TODO: handle number?
#endif
    [currentSample stop];
}/* os_stop_sample */

/**
 * os_finish_with_sample
 *
 * Remove the current sample from memory (if any).
 *
 */
void os_finish_with_sample(int number)
{
#if !(defined(EMULATE_OSS_SOUND_BEHAVIOR) && EMULATE_OSS_SOUND_BEHAVIOR)
    @autoreleasepool {
        if (samples[@(number)] == currentSample) {
            [currentSample pause];
            currentSample = nil;
        }
        [samples removeObjectForKey:@(number)];
    }
#else
    os_stop_sample(number);
    currentSample = nil;
#endif
}/* os_finish_with_sample */

/**
 * os_wait_sample
 *
 * Stop repeating the current sample and wait until it finishes.
 *
 */
void os_wait_sample (void)
{
    @autoreleasepool {
        currentSample.numberOfLoops = 0;
        while (currentSample.playing) {
            usleep(200);
        }
    }
}/* os_wait_sample */

