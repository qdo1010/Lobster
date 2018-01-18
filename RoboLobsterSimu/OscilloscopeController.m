
#import "OscilloscopeController.h"//Hi Quan, this is my 2nd edit. It's where I have pointed to sections that confuse me.
#import "AppDelegate.h"
#import "analysisWindowController.h"
//#import "GraphViewController.h"
//#import "GraphicsView.h"
#import "Waveforms.h"
//#import "DSPSources.h"
//#import "signalProcessing.h"
#import "OscilloscopeView.h"
//#import "VideoPlaybackController.h"

@implementation OscilloscopeController //

    // These placeholders fill in for the 32bit Quicktime 7 Audio Extraction API
typedef id MovieAudioExtractionRef;

#pragma mark -
#pragma mark Properties

@synthesize sweepOffset = _sweepOffset; //each of these should be explained
@synthesize sweepTerminus = _sweepTerminus;
@synthesize samplingDuration = _samplingDuration;
@synthesize sweepDuration = _sweepDuration;
@synthesize sweepMaximum = _sweepMaximum;
@synthesize samplingRate = _samplingRate;
@synthesize samplingOffset = _samplingOffset;
@synthesize samplingTerminus = _samplingTerminus;

@synthesize sweepDurationSlider;
@synthesize sweepDurationTextBox;
@synthesize sweepOffsetSlider;
@synthesize sweepOffsetTextBox;

@synthesize traceGainSlider;
@synthesize traceOffsetSlider;
@synthesize traceGainTextBox;
@synthesize traceOffsetTextBox;

@synthesize sampsPerCol = _sampsPerCol;
@synthesize proxGain = _proxGain;
@synthesize proxOffset = _proxOffset;
@synthesize proxGainMax = proxGainMax;

@synthesize samplingMaximum = _samplingMaximum;
@synthesize numColumns = _numColumns;

@synthesize index = _index;
@synthesize assetInited = _assetInited;
@synthesize doInitAndScale = _doInitAndScale;
@synthesize drawSpikes = _drawSpikes;
@synthesize drawClusteredSpikes = _drawClusteredSpikes;
@synthesize drawNoiseLevel = _drawNoiseLevel;
@synthesize drawCluster = _drawCluster;
@synthesize maxIp = _maxIp;
@synthesize minIp = _minIp;
@synthesize timeScale = _timeScale;
@synthesize traceIDchosen;
@synthesize AllTracesInfo;
@synthesize IndividualTraceInfo;
@synthesize displayTraceID;

@synthesize gainStepView;

-(id) init//what is happening here?
{
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        //    [self setOscilloscopeView:oscilloscopeView];
    self  = [super init];
    
    if(self){
		//        int ProxOffset, DistOffset;
     //   NSRect  iRect = [[[appDelegate analysisWindowController] oscilloscopeView] bounds];
        NSLog(@"setting up");
       // [self   setProxOffset:(iRect.size.height / 3)];
       [self setTitle:@"Oscilloscope"];
      
    //}
       // [cellSelector removeAllItems];
       // [cellSelector addItemWithTitle:@"cellElevatorL1"];
    }
    return self;
    }

- (void) awakeFromNib {
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    [[appDelegate analysisWindowController] setOscilloscopeController:self];
    NSLog(@"Executing awakeFromNib in Oscilloscope Controller");
    
   // AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    [displayTraceID removeAllItems];
    for (int i = 0; i < [[[appDelegate traceSelector] traceArraytobeSent] count]; i ++){
        [displayTraceID addItemWithTitle:[NSString stringWithFormat:@"%d", i]];
        [[appDelegate durationArray] addObject:[NSString stringWithFormat:@"%d", 5000]];
        [[appDelegate offsetArray] addObject:[NSString stringWithFormat:@"%d", 0]];
        [[appDelegate traceGainArray] addObject:[NSString stringWithFormat:@"%d", 1]];
        [[appDelegate traceOffsetArray] addObject:[NSString stringWithFormat:@"%d", 0]];
    }
    
     NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 1                                                  target: self
                                                selector:@selector(beginSendingStuffToBeDrawn)
                                              userInfo: nil repeats:YES];
           // [self setOscilloscopeView:oscilloscopeView];
}

- (void) importAudioFromFile:(id)sender
{
	_doInitAndScale = YES;
	_drawSpikes = YES;
	_drawClusteredSpikes = NO;
	_drawNoiseLevel = NO;
	_drawCluster = NO;
}

/*   These are the sampling properties for the Oscilloscope and Chart displays
long   samplingOffset;     //Sweep offset from origin in samples
long   samplingTerminus;   //Sweep Terminus from origin in samples
long   samplingMaximum;    //Duration of file in samples
double samplingDuration;   //Duration of Sweep in samples
 
double samplingRate;       //SamplingRate in Hz
long   numColumns;          //Number of columns in the display
double sampsPerCol;        //Samples per Pixel
 
double sweepOffset;        //Sweep offset from origin in Sec
double sweepTerminus;      //Terminus of Sweep in Sec
double sweepDuration;      //Duration of Sweep in Sec
double sweepMaximum;       //Duration of file in Sec
 */

/*
- (void)initScopeSweep{                                         //Initialize [self with the current file data
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
   // [[appDelegate traceWaveforms] sendToBuffer:cellDepressorL2 :100];
	if (!self.assetInited)
            //		[self loadDSPSourceFromAsset:appDelegate.movieController.videoPlaybackController.asset];
	//    NSRect iRect = [[[appDelegate analysisWindowController] oscilloscopeView] bounds];
        //    [[self setNumColumns:        iRect.size.width];              //This is the width of the graphics window
    [self setNumColumns: 754];              //This is the width of the oscilloscopeView
  //  [self setSamplingMaximum:1000]; //added this too
	[self setSampsPerCol:(      _samplingMaximum/_numColumns)];          //This is the gain of the timebase in samples/col
	[self setSamplingOffset:    0];                             //This is the pointer for the  offset of the data sample
    [self setSamplingTerminus:  _samplingMaximum];                      //This is the pointer for the terminus of the data sample
    [self setSweepOffset:       0.0];                           //This is the sweep onset in sec
    [self setSweepTerminus:     _samplingMaximum/_samplingRate];         //This is the sweep terminus in sec.
    [self setSamplingDuration:  _samplingMaximum];
    NSLog(@"\nFollowing initScopeSweep\n samplingMaximum: %ld \n samplingDuration: %ld \n numColumns: %ld \n samplingOffset: %ld \n samplingTerminus: %ld \n samplingRate: %8.1f \n sampsPerCol: %8.1f \n sweepOffset: %8.3f \n sweepTerminus: %8.3f \n sweepDuration: %8.3f \n sweepMaximum: %8.3f ",
          [self samplingMaximum],
          [self samplingDuration],
          [self numColumns],
          [self samplingOffset],
          [self samplingTerminus],
          [self samplingRate],
          [self sampsPerCol],
          [self sweepOffset],
          [self sweepTerminus],
          [self sweepDuration],
          [self sweepMaximum]
          );
    [[appDelegate analysisWindowController] setScopeInited:YES];
}*/

- (void)logScopeSweep{   //Log Contents of self with the current file data
						 //    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    NSLog(@"\nScope Sweep Parameters\n samplingMaximum: %ld \n samplingDuration: %ld \n numColumns: %ld \n samplingOffset: %ld \n samplingTerminus: %ld \n samplingRate: %8.1f \n sampsPerCol: %8.1f \n sweepOffset: %8.3f \n sweepTerminus: %8.3f \n sweepDuration: %8.3f \n sweepMaximum: %8.3f ",
          [self samplingMaximum],
          [self samplingDuration],
          [self numColumns],
          [self samplingOffset],
          [self samplingTerminus],
          [self samplingRate],
          [self sampsPerCol],
          [self sweepOffset],
          [self sweepTerminus],
          [self sweepDuration],
          [self sweepMaximum]
          );
}
/*
- (void)scaleScopeSweep{
	int samp;
   AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];

	_maxIp = [[[[appDelegate traceWaveforms] ipbuf] objectAtIndex:0] floatValue];
	_minIp = [[[[appDelegate traceWaveforms] ipbuf] objectAtIndex:0] floatValue];
	
	for (samp = 0; samp < [[[appDelegate traceWaveforms] ipbuf] count]; samp++) {
		
			
			if ([[[[appDelegate traceWaveforms] ipbuf] objectAtIndex:samp] floatValue] >= _maxIp) {
				_maxIp = [[[[appDelegate traceWaveforms] ipbuf] objectAtIndex:samp] floatValue];
                NSLog(@" max = %f", _maxIp);
			}
			
			if ([[[[appDelegate traceWaveforms] ipbuf] objectAtIndex:samp] floatValue] <= _minIp)
				{
					_minIp = [[[[appDelegate traceWaveforms] ipbuf] objectAtIndex:samp] floatValue];
                    NSLog(@" min = %f", _minIp);
				}
		}

	
    NSRect iRect = [[[appDelegate analysisWindowController] oscilloscopeView] bounds];

	if (_maxIp > _minIp * -1) {
        _proxGain = iRect.size.height / (_maxIp * 3);
    } else
        _proxGain = iRect.size.height / (_minIp * -3);
	proxGainMax = _proxGain;
    NSLog(@"In ScaleSweep: proxGain is %f ", _proxGain);
		
}
*/


- (void)setDoInitAndScale:(BOOL)flag{
	_doInitAndScale = flag;
}

#pragma mark --IBAction for Oscilloscope Drawer--
    //Timebase Variables

/*   These are the sampling properties for the Oscilloscope and Chart displays
 long   samplingOffset;     //Sweep offset from origin in samples
 long   samplingTerminus;   //Sweep Terminus from origin in samples
 long   samplingMaximum;    //Duration of file in samples
 double samplingDuration;   //Duration of Sweep in samples
 
 double samplingRate;       //SamplingRate in Hz
 long   numColumns;         //Number of columns in the display
 double sampsPerCol;        //Samples per Pixel
 
 double sweepOffset;        //Sweep offset from origin in Sec
 double sweepTerminus;      //Terminus of Sweep in Sec
 double sweepDuration;      //Duration of Sweep in Sec
 double sweepMaximum;       //Duration of file in Sec
 */

#pragma mark --Display controls for timebase and waveform--

/*
- (IBAction) resetSweepOffset: (id) sender{
    
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    NSRect iRect = [[[appDelegate analysisWindowController] oscilloscopeView] bounds];
    [self setNumColumns:        iRect.size.width];              //This is the width of the graphics window
	[self setDoInitAndScale:    NO];
    [self setSweepOffset:       [sender doubleValue]];          //Read the slider value here
    [self setSamplingOffset:    [self sweepOffset]*[self samplingRate]];
    NSLog(@"resetSweepOffset returns %8.3f",[sender doubleValue]);
    
        //First Compute parameters in Seconds
    long sweepMaxDur = [self sweepMaximum] - [self sweepOffset];
    if([self sweepDuration] > sweepMaxDur)
        [self setSweepDuration:sweepMaxDur];
       [self setSweepTerminus:[self sweepOffset]+[self sweepDuration]];
    
    [self setSamplingOffset:    [self sweepOffset]*[self samplingRate]];   //  <====The slider returns the offset
    [self setSamplingTerminus: [self sweepTerminus]*[self samplingRate]];
    [self setSamplingDuration:  [self samplingTerminus] - [self samplingOffset]];
	[self setSampsPerCol:(      [self samplingDuration] / [self numColumns])]; //This is the gain of the timebase in samples/col
    [self scaleScopeSweep];

    NSLog(@"\nFollowing resetSweepOffset\n samplingMaximum: %ld \n numColumns: %ld \n samplingOffset: %ld \n samplingTerminus: %ld \n samplingDuration: %ld \n samplingRate: %8.1f \n sampsPerCol: %8.1f \n sweepOffset: %8.3f \n sweepTerminus: %8.3f \n sweepDuration: %8.3f \n sweepMaximum: %8.3f ",
          [self samplingMaximum],
          [self numColumns],
          [self samplingOffset],
          [self samplingTerminus],
          [self samplingDuration],
          [self samplingRate],
          [self sampsPerCol],
          [self sweepOffset],
          [self sweepTerminus],
          [self sweepDuration],
          [self sweepMaximum]
          );
	[[[appDelegate analysisWindowController] myCurrentView] setNeedsDisplay:YES];
        //[[self self] drawScopeSweep ];//]:rect];
	
}*/

- (IBAction)chooseTraceID:(id)sender {
    traceIDchosen = [[[self displayTraceID] title] integerValue];
    NSLog(@" choose this trace %d", traceIDchosen);
}

- (IBAction)changeGainStep:(id)sender {
    [gainStepView setIncrement: 0.1];
    [gainStepView setMaxValue: 10.0];
    
    [traceGainSlider setFloatValue:[sender floatValue]];
    [traceGainTextBox setFloatValue:[sender floatValue]];

}


/*
- (IBAction) resetSweepDuration: (id) sender{          //Reset Samples Per Column
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    NSRect iRect = [[[appDelegate analysisWindowController] oscilloscopeView] bounds];
	[self setDoInitAndScale:NO];
    [self setNumColumns:        iRect.size.width];              //This is the width of the graphics window
    [self setSweepDuration:[sender doubleValue]];
      NSLog(@"resetSweepDuration returns %8.3f",[sender doubleValue]);
    
    [self setSamplingOffset:[self sweepOffset]*[self samplingRate]];
    long sTerm =   ([self sweepDuration]+[self sweepOffset])*[self samplingRate];
    if (sTerm > [self samplingMaximum]) {
        sTerm = [self samplingMaximum];
    }
    [self setSamplingTerminus:sTerm];
    [self setSamplingDuration:  [self samplingTerminus] - [self samplingOffset]];
    [self setSweepOffset:       [self samplingOffset]/[self samplingRate]];                           //This is the sweep onset in sec
    [self setSweepTerminus:     [self samplingTerminus]/[self samplingRate]];                         //This is the sweep terminus in sec.
    
    [self setSamplingDuration: [self samplingTerminus] - [self samplingOffset]];  //This is the duraion of the sweep in samples
	
    [self setSampsPerCol:[self samplingDuration]/[self numColumns]];
    
    [self scaleScopeSweep];
    NSLog(@"\nFollowing resetSweepDuration\n samplingMaximum:%ld \n numColumns:%ld \n samplingOffset:%ld \n samplingTerminus: %ld \n samplingDuration: %ld \n  samplingRate:%8.0f \n sampsPerCol:      %8.0f \n sweepOffset:%8.3f \n sweepTerminus:%8.3f \n  sweepDuration:%8.3f \n  sweepMaximum:%8.3f ",
          
          [self samplingMaximum],
          [self numColumns],
          [self samplingOffset],
          [self samplingTerminus],
          [self samplingDuration],
          [self samplingRate],
          [self sampsPerCol],
          [self sweepOffset],
          [self sweepTerminus],
          [self sweepDuration],
          [self sweepMaximum]);
 	[[[appDelegate analysisWindowController] myCurrentView] setNeedsDisplay:YES];
        //[[self self] drawScopeSweep ];//]:rect];
}*/

/*

- (IBAction) resetGainProx: (id) sender{
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
	float percent;
	float ProxGain;
	float oscProxGainMax = [self proxGainMax];
	[self setDoInitAndScale:NO];
	percent = [sender intValue];
	ProxGain =  (oscProxGainMax / 100) * percent;
	[self setProxGain:ProxGain];
	
	[[[appDelegate analysisWindowController] myCurrentView] setNeedsDisplay:YES];
	
}


- (IBAction) resetOffsetProx: (id) sender{
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
	float percent;
	int ProxOffset;
	[self setDoInitAndScale:NO];
	percent = [sender intValue];
    NSRect  iRect = [[[appDelegate analysisWindowController] myCurrentView] bounds];
        //    NSRect irect = [[[[appDelegate analysisWindowController] myCurrentView] gRect];
	ProxOffset =  ((iRect.size.height / 2) / 100) * percent + iRect.size.height / 2;
	[self setProxOffset:ProxOffset];
	[[[appDelegate analysisWindowController] myCurrentView] setNeedsDisplay:YES];
	
}*/


- (IBAction) invertProxGraph: (id)sender{
	AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
	int i = [appDelegate invertSign];
    if (i == 0){
        [appDelegate setInvertSign:1];
    }
    else{
        [appDelegate setInvertSign:0];
    }
	/*
    for (i = 0; i < [[[appDelegate traceWaveforms] ipbuf] count]; i++) {
		
        if ([[[[appDelegate traceWaveforms] ipbuf] objectAtIndex:i] floatValue] < 0) {
            [[[appDelegate traceWaveforms] ipbuf] replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:-([[[[appDelegate traceWaveforms] ipbuf] objectAtIndex:i] floatValue])]];
            
        }
        else if ([[[[appDelegate traceWaveforms] ipbuf] objectAtIndex:i] floatValue] > 0) {
            [[[appDelegate traceWaveforms] ipbuf] replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:-([[[[appDelegate traceWaveforms] ipbuf] objectAtIndex:i] floatValue])]];
            
        }
	}*/
	//[[[appDelegate analysisWindowController] myCurrentView] setNeedsDisplay:YES];
}


  ///this is to change sweep duration, so to zoom in!
- (IBAction)changeSweepDuration:(id)sender {
    traceIDchosen = [[[self displayTraceID] title] integerValue];
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    [sweepDurationSlider setMinValue:0];
    [sweepDurationSlider setMaxValue:10000];
   // NSLog(@"%d", [sweepDurationSlider intValue]);
    [sweepDurationTextBox setStringValue:[NSString stringWithFormat:@"%f",0.001*elapsed*[sweepDurationSlider intValue]]];
    //change duration array
    for (int i = 0; i < [[[appDelegate traceSelector] traceArraytobeSent] count]; i ++){
    [[appDelegate durationArray] replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[sweepDurationSlider intValue]]];
    }
 //   sweepDurationTextBox.text =
}

- (IBAction)changeSweepOffset:(id)sender {
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    [sweepOffsetSlider setMinValue:0];
    [sweepOffsetSlider setMaxValue:10000];
    // NSLog(@"%d", [sweepDurationSlider intValue]);
    [sweepOffsetTextBox setStringValue:[NSString stringWithFormat:@"%f",0.001*elapsed*[sweepOffsetSlider intValue]]];
   // NSLog(@"trace chosen = %d", traceIDchosen);
    for (int i = 0; i < [[[appDelegate traceSelector] traceArraytobeSent] count]; i ++){
        [[appDelegate offsetArray] replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[sweepOffsetSlider intValue]]];
    }
    
}

- (IBAction)displayString:(id)sender {
}

- (IBAction)changeTraceGain:(id)sender {
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    [traceGainSlider setMinValue:1];
    [traceGainSlider setMaxValue:10];
    // NSLog(@"%d", [sweepDurationSlider intValue]);
    [traceGainTextBox setStringValue:[NSString stringWithFormat:@"%f",[traceGainSlider floatValue]]];

    //replace array value
     [[appDelegate traceGainArray] replaceObjectAtIndex:traceIDchosen withObject:[NSString stringWithFormat:@"%f",[traceGainSlider floatValue]]];
    
}



- (IBAction)changeTraceOffset:(id)sender {
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    [traceOffsetSlider setMinValue:0];
    [traceOffsetSlider setMaxValue:1000];
    // NSLog(@"%d", [sweepDurationSlider intValue]);
    [traceOffsetTextBox setStringValue:[NSString stringWithFormat:@"%f", [traceOffsetSlider floatValue]]];
    
    //replace array value
    [[appDelegate traceOffsetArray] replaceObjectAtIndex:traceIDchosen withObject:[NSString stringWithFormat:@"%f",[traceOffsetSlider floatValue]]];
}

- (void)beginSendingStuffToBeDrawn {
    
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
   // if ([[appDelegate offsetArray] count] != [[[appDelegate traceSelector] traceArraytobeSent] count]  || ([[appDelegat/e durationArray] count] != [[[appDelegate traceSelector] traceArraytobeSent] count])){
     //           _startButton.enabled = NO;
      //      }
    //else{
        
      //  _startButton.enabled = YES;
       // NSLog(@"is it doing anything?");
        [appDelegate displaySampledWaveforms: [[appDelegate traceSelector] traceArraytobeSent]  : [appDelegate offsetArray] :[appDelegate durationArray]];
    
        
    //}
  //  [displayTraceID removeAllItems];
  //  for (int i; i < [[[appDelegate traceSelector] traceArraytobeSent] count]; i ++){
  //      [displayTraceID addItemWithTitle:[NSString stringWithFormat:@"%d", i]];
  //  }
}
- (IBAction)changeView:(id)sender {
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    if ([appDelegate switchColor] == 0){
    [appDelegate setSwitchColor: 1];
    }
    else{
        [appDelegate setSwitchColor:0];
    }
}
@end
