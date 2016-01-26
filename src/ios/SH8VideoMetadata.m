#import "SH8VideoMetadata.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@implementation SH8VideoMetadata;

static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

- (void)file:(CDVInvokedUrlCommand*)command
{
    
    NSString* callbackId = [command callbackId];
    NSString* file = [[command arguments] objectAtIndex:0];
    
    AVAssetTrack *videoTrack = nil;
    AVURLAsset *asset = nil;
    
    if ([file containsString:@"file:"]) {
        asset = [AVAsset assetWithURL:[NSURL URLWithString:file]];
    } else {
        asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:file]];
    }

    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    
    CMFormatDescriptionRef formatDescription = NULL;
    
    NSArray *formatDescriptions = [videoTrack formatDescriptions];
    
    if ([formatDescriptions count] > 0)
        formatDescription = (__bridge CMFormatDescriptionRef)[formatDescriptions objectAtIndex:0];
    
    if ([videoTracks count] > 0)
        videoTrack = [videoTracks objectAtIndex:0];
    
    CGSize trackDimensions = {
        .width = 0.0,
        .height = 0.0,
    };
    
    trackDimensions = [videoTrack naturalSize];
    
    int width = trackDimensions.width;
    int height = trackDimensions.height;
    
    CGAffineTransform txf = [videoTrack preferredTransform];
    CGFloat rotation = RadiansToDegrees(atan2(txf.b, txf.a));
    
    float duration = CMTimeGetSeconds(videoTrack.timeRange.duration);
    float bitrate = [videoTrack estimatedDataRate];
    
    NSDictionary *jsonResult = [ [NSDictionary alloc]
                                initWithObjectsAndKeys:
                                [NSNumber numberWithInteger: width], @"width",
                                [NSNumber numberWithInteger: height], @"height",
                                [NSNumber numberWithFloat: rotation], @"rotation",
                                [NSNumber numberWithFloat: duration], @"duration",
                                [NSNumber numberWithFloat: bitrate], @"bitrate",
                                nil
                                ];
    
    CDVPluginResult* pluginResult = [ CDVPluginResult
                                     resultWithStatus: CDVCommandStatus_OK
                                     messageAsDictionary: jsonResult
                                     ];
    
    [self.commandDelegate sendPluginResult: pluginResult callbackId: command.callbackId];
}

@end