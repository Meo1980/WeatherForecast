//
//  HTTPDownloader.h
//  GET Example
//
//  Created by Le van Thang on 6/19/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <CFNetwork/CFNetwork.h>


#define BUFFER_SIZE	(2048)

@interface HTTPDownloader : NSObject 
{
    NSURL*				_url;
    CFReadStreamRef		_stream;
    CFHTTPMessageRef	_request;
	NSFileHandle*		_fileHandle;
	long long			_lDownloadBytes;
	long long			_expectedDataLength;
	id					_delegate;
	NSString*			_strDestination;
	NSThread*			_downloadThread;
}

@property (nonatomic, readonly) long long			_expectedDataLength;
@property (nonatomic, readonly) long long			_lDownloadBytes;

- (id) delegate;

- (int) downloadURL: (NSURL*) url toDestination: (NSString*) dest delegate: (id) delegate;

- (void) setCookieForRequest: (CFHTTPMessageRef) request:(NSURL *)url;

- (int)fetch:(CFHTTPMessageRef)request;

- (void)handleNetworkEvent:(CFStreamEventType)type;
- (void)handleOpenCompleted; 
- (void)handleBytesAvailable; 
- (void)handleStreamComplete;
- (void)handleStreamError;

- (NSURL*) url;

- (void) stopDownloading;
- (void) downloadThread: (NSURL*) url;

@end
