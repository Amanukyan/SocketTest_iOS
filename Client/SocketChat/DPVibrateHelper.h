//
//  VibrateHelper.h
//  CameraOllieTest
//
//  Created by ILYA2606 on 14.03.16.
//  Copyright © 2016 Darkness Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class DPVibration;

@interface DPVibrateHelper : NSObject

/**
 Vibrate action from duration
 
 @author Ilya Shkolnik
 @param duration Duration in milliseconds
 */
+(void)vibrateWithDuration:(long)duration;

/**
 Vibrate action from Vibrate object
 
 @author Ilya Shkolnik
 @param vibrate Vibrate object
 */
+(void)vibrateWithVibration:(nonnull DPVibration*)vibration;

/**
 Vibrate action from Vibrate objects
 
 @author Ilya Shkolnik
 @param vibrates Vibrate objects sequence
 */
+(void)vibrateWithVibrations:(nonnull DPVibration*)vibrations, ... NS_REQUIRES_NIL_TERMINATION;

@end


@interface DPVibration : NSObject

/*!
 * Vibration duration in milliseconds
 */
@property (nonatomic) long duration;

/*!
 * Delay duration before vibration in milliseconds
 */
@property (nonatomic) long delayDuration;

/**
 Vibration object from duration
 
 @author Ilya Shkolnik
 @param duration Duration in milliseconds
 @return Vibration object
 */
+(nonnull instancetype)vibrationWithDuration:(long)duration;

/**
 Vibration object from duration
 
 @author Ilya Shkolnik
 @param duration Duration in milliseconds
 @param delayDuration Delay duration before vibration in milliseconds
 @return Vibration object
 */
+(nonnull instancetype)vibrationWithDuration:(long)duration delayDuration:(long)delayDuration;

@end