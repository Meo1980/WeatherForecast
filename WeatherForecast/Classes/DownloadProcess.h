//
//  DownloadProcess.h
//  9999Truyen
//
//  Created by bugun on 4/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NameViewController.h"
//#import "ArtistContentViewController.h"
//#import "TypeContentViewController.h"
//#import "FavouriteViewController.h"

@class HTTPDownloader;

@interface DownloadProcess : NSObject
{
	NSString* _storyName;
	HTTPDownloader*		_downloader;
	NSInteger			_iDownloadChapter;
}

@property (nonatomic, retain) NSString* storyName;

//- (void) downloadStoryProgress;
- (void) startDownloadStory;
- (void) continueDownloadStory;
//- (void) downloadStoryInformationAndPageOne;
- (NSString*) convertLink:(NSString *)encriptedString;
- (void) writeContentOfFile: (NSString*) strContent fileName: (NSString*) fileName;
- (void) updateProgressUI;

- (void) downloadFailed;
- (void) stopDownloading;

@end
