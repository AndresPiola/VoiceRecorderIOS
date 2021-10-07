//
//  ViewController.m
//  VoiceRecorder
//
//  Created by andres on 07-10-21.
//

#import "ViewController.h"
 
@interface ViewController ()

@end

@implementation ViewController

@synthesize recorder,recorderSettings,recorderFilePath;
@synthesize audioPlayer,audioFileName;

 
#pragma mark - View Controller Life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Audio Recording
- (IBAction)startRecording:(id)sender
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err)
    {
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err)
    {
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSURL *tmpFileUrl = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"Mustakistmp.m4a"]];
    
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                            [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                            [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                            nil];
    
     
    
     err = nil;
    recorder = [[ AVAudioRecorder alloc] initWithURL:tmpFileUrl settings:recordSettings error:&err];
    if(!recorder){
        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning" message: [err localizedDescription] delegate: nil
                         cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //prepare to record
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.isInputAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"message: @"Audio input hardware not available"
                                  delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
    }
    
    // start recording
    [recorder recordForDuration:(NSTimeInterval) 60];//Maximum recording time : 60 seconds default
    NSLog(@"Recroding Started");
}

- (IBAction)stopRecording:(id)sender
{
    [recorder stop];
    NSLog(@"Recording Stopped");
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSURL *tmpFileUrl = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"Mustakistmp.m4a"]];
    NSString *urlString=tmpFileUrl.absoluteString;
    NSLog (@"audioRecorderDidFinishRecording:successfully: %@ ",urlString);
}


#pragma mark - Audio Playing
- (IBAction)startPlaying:(id)sender
{
    NSLog(@"playRecording");
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
     NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSURL *tmpFileUrl = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"Mustakistmp.m4a"]];
   
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tmpFileUrl error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}
- (IBAction)stopPlaying:(id)sender
{
    [audioPlayer stop];
    NSLog(@"stopped");
}

 

@end
