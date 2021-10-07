//
//  ViewController.h
//  VoiceRecorder
//
//  Created by andres on 07-10-21.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
     
    
}
@property(nonatomic,strong) AVAudioRecorder *recorder;
@property(nonatomic,strong) NSMutableDictionary *recorderSettings;
@property(nonatomic,strong) NSString *recorderFilePath;
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,strong) NSString *audioFileName;
-(IBAction) startRecording;
-(IBAction) stopRecording;
-(IBAction) playRecording;
-(IBAction) stopPlaying;


@end

