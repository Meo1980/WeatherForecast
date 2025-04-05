//
//  HTTPDownloader.m
//  GET Example
//
//  Created by Le van Thang on 6/19/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "HTTPDownloader.h"

#pragma mark -
#pragma mark Constants & Globals
static const CFOptionFlags kNetworkEvents = kCFStreamEventOpenCompleted |
                                            kCFStreamEventHasBytesAvailable |
                                            kCFStreamEventEndEncountered |
											kCFStreamEventErrorOccurred;


#pragma mark -

#pragma mark -
#pragma mark Static Functions
static void
ReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType type, void *clientCallBackInfo) 
{
    // Pass off to the object to handle.
    [((HTTPDownloader*)clientCallBackInfo) handleNetworkEvent: type];
}


#pragma mark -

@implementation HTTPDownloader

@synthesize _expectedDataLength;
@synthesize _lDownloadBytes;

- (id) init 
{
	self = [super init];
	if (self != nil) 
	{
		_fileHandle = nil;
		_url = nil;
		_stream = nil;
		_request = nil;
		_expectedDataLength = 0;
		_strDestination = nil;
		_downloadThread = nil;
	}
	return self;
}

- (void) dealloc 
{
	[_strDestination release];

	[_fileHandle release];
	[_url release];
	if(_request)
	{
		CFRelease(_request);
	}	
	if(_stream)
	{
		CFReadStreamClose(_stream);
		CFRelease(_stream);
	}	

	[_downloadThread release];
	
	[super dealloc];
}

- (id) delegate
{
	return _delegate;
}

- (long long) downloadBytes
{
	return _lDownloadBytes;
}

- (NSURL*) url
{
	return _url;
}

- (void) setCookieForRequest: (CFHTTPMessageRef) request:(NSURL *)url
{
	NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray * cookies = [cookieStorage cookiesForURL: url];
	if(cookies && ([cookies count] > 0))
	{
		NSDictionary* headersCookie = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
		NSString* cookieDesc = [headersCookie objectForKey:@"Cookie"];
		if(cookieDesc != nil)
		{
			// Add the key - value to request
			//CFHTTPMessageSetHeaderFieldValue(request, CFSTR("Referer"), (CFStringRef)[url path]);
			CFHTTPMessageSetHeaderFieldValue(request, CFSTR("Cookie"), (CFStringRef)cookieDesc);

		}	
	}		
}

- (void) downloadThread: (NSURL*) url
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"GET"];
	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
	
	if(_downloadThread) // Not cancelled yet
	{
		if (data == nil) 
		{
			NSLog(@"Error: could not get story");
			if(_delegate && [_delegate respondsToSelector:@selector(downloader:failedDownloadingFile:)])
			{
				[_delegate downloader:self failedDownloadingFile: _strDestination];
			}
		}
		else
		{
			[data writeToFile: _strDestination atomically: YES];
			if(_delegate && [_delegate respondsToSelector:@selector(downloader: finshedDownloadingFile: title: url:)])
			{
				[_delegate downloader:self finshedDownloadingFile: _strDestination title: @"Untitled" url: [_url absoluteString]];
			}
		}
	}
	
	[pool release];
}

- (int) downloadURL: (NSURL*) url toDestination: (NSString*) dest delegate: (id) delegate
{
	int iRet = 0;
	_delegate = delegate;
	_lDownloadBytes = 0;
	[_strDestination release];
	_strDestination = [dest retain];
	
	//[self performSelectorInBackground: @selector(downloadThread:) withObject: url];
	[_downloadThread release];
	_downloadThread = [[NSThread alloc] initWithTarget: self selector: @selector(downloadThread:) object: url];
	[_downloadThread start];
	
#if 0	
    CFHTTPMessageRef request;
    NSString* url_string = [url path];

    // Make sure there is a string in the text field
    if (!url_string || ![url_string length]) 
	{
        return -50;
    }
    
	[_url release];
    // Create a new url based upon the input url
    _url = [url retain];
    
    // Create a new HTTP request.
    request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef)_url, kCFHTTPVersion1_1);
    if (!request) 
	{
        return 1;
    }
 
    CFHTTPMessageSetHeaderFieldValue(request, CFSTR("User-Agent"), 
						CFSTR("Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/125.5.7 (KHTML, like Gecko) Safari/125.12"));
	[self setCookieForRequest: request: url];
	
    // Start the fetch.
    iRet = [self fetch: request];
    
    // Release the request.  The fetch should've retained it if it
    // is performing the fetch.
    CFRelease(request);
#endif
	return iRet;
}


- (int)fetch:(CFHTTPMessageRef)request
{
	int iRet = 0;
    
    CFHTTPMessageRef old;
	CFReadStreamRef stream;
    CFStreamClientContext ctxt = {0, self, NULL, NULL, NULL};
    
    // Swap the old request and the new request.  It is done in this
    // order since the new request could be the same as the existing
    // request.  If the old one is released first, it could be destroyed
    // before retain.
    old = _request;
    _request = (CFHTTPMessageRef)CFRetain(request);
    if (old)
	{
        CFRelease(old);
    }
	
    // Create the stream for the request.
    stream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, _request);

    // Make sure it succeeded.
    if (!stream) 
	{
        return 1;
    }
    
    // auto-redirect
    CFReadStreamSetProperty( stream, kCFStreamPropertyHTTPShouldAutoredirect, kCFBooleanFalse );
//    CFReadStreamSetProperty( stream, kCFStreamPropertyHTTPShouldAutoredirect, _bRedirect ? kCFBooleanTrue : kCFBooleanFalse);

	// Use persistent conections so connection-based authentications work correctly.
	//CFReadStreamSetProperty(stream, kCFStreamPropertyHTTPAttemptPersistentConnection, kCFBooleanTrue);
	
    // Set the client
    if (!CFReadStreamSetClient(stream, kNetworkEvents, ReadStreamClientCallBack, &ctxt)) 
	{
        CFRelease(stream);
        return 2;
    }
    
    // Schedule the stream
    CFReadStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    
    // Start the HTTP connection
    if (!CFReadStreamOpen(stream)) 
	{
        CFReadStreamSetClient(stream, 0, NULL, NULL);
        CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        CFRelease(stream);
        return 3;
    }
    
    // Don't need the old stream any more.
	if (_stream) 
	{
		
		// This may seem odd to close the old stream at this point.
		// A persistent connection's underlying connection will be held
		// as long as there is one stream left in the "not closed"
		// state (the stream may be at the end but the actual Close
		// function has not be called).  The new stream is being opened
		// before the old one closes, so if the stream is to the same
		// server with the same properties, the same pipe will be used.
		// It's very important to use the same pipe for authentication
		// methods such as NTLM.
		CFReadStreamClose(_stream);
		CFRelease(_stream);
	}
	
	_stream = stream;
	
	return iRet;
}


- (void)handleNetworkEvent:(CFStreamEventType)type 
{

   // Dispatch the stream events.
    switch (type) 
	{
		case kCFStreamEventOpenCompleted:
            [self handleOpenCompleted];
            break;
		
        case kCFStreamEventHasBytesAvailable:
            [self handleBytesAvailable];
            break;
            
        case kCFStreamEventEndEncountered:
            [self handleStreamComplete];
            break;
            
        case kCFStreamEventErrorOccurred:
            [self handleStreamError];
            break;
            
        default:
            break;
    }
}

- (void)handleOpenCompleted 
{
    if(_fileHandle == nil)
	{
		CFURLRef url = (CFURLRef)CFReadStreamCopyProperty(_stream, kCFStreamPropertyHTTPFinalURL);
		if(url)
		{
			if(_fileHandle)
			{
				[_fileHandle closeFile];
				[_fileHandle release];
				_fileHandle = nil;
			}
			
			NSFileManager* fileManager = [NSFileManager defaultManager];
			if(![fileManager fileExistsAtPath: _strDestination])
			{
				[fileManager createFileAtPath:_strDestination contents: nil attributes: nil];
			}
			_fileHandle = [NSFileHandle fileHandleForWritingAtPath: _strDestination];
			[_fileHandle retain];
			

			CFRelease(url);
			
		}
	}
}


- (void)handleBytesAvailable 
{
	if(_fileHandle == nil)
	{
		NSLog(@"handleBytesAvailable: Download has invalid file handle.\n");
		return;
	}

	if(_expectedDataLength == 0)
	{
		CFHTTPMessageRef response = (CFHTTPMessageRef)CFReadStreamCopyProperty(_stream, kCFStreamPropertyHTTPResponseHeader);
		if (response) 
		{
			CFStringRef contentLengthString = CFHTTPMessageCopyHeaderFieldValue(response, CFSTR("Content-Length"));
			if (contentLengthString) 
			{
				_expectedDataLength = [(NSString *)contentLengthString longLongValue];
				CFRelease(contentLengthString);
			}
			
			CFRelease(response);
		}				
	}	
	
    UInt8 buffer[BUFFER_SIZE];
    CFIndex bytesRead = CFReadStreamRead(_stream, buffer, BUFFER_SIZE);
    
    // Less than zero is an error
    if (bytesRead < 0)
	{
        [self handleStreamError];
    }
    // If zero bytes were read, wait for the EOF to come.
    else if (bytesRead > 0)
	{
		NSData* tempData = 	 [NSData dataWithBytes:buffer length: bytesRead];	
		[_fileHandle writeData: tempData];
		_lDownloadBytes += bytesRead;
    }

}


- (void)handleStreamComplete 
{
    
    CFHTTPMessageRef response = (CFHTTPMessageRef)CFReadStreamCopyProperty(_stream, kCFStreamPropertyHTTPResponseHeader);
//	NSURL* finalURL = (NSURL*)CFReadStreamCopyProperty(_stream, kCFStreamPropertyHTTPFinalURL); 
	// Remove the stream from the run loop and such.  Don't close the connection
	// yet.  See the note in -fetch:.
	CFReadStreamSetClient(_stream, 0, NULL, NULL);
	CFReadStreamUnscheduleFromRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

	// Close current file handle
	if(_fileHandle)
	{
		[_fileHandle closeFile];
		[_fileHandle release];
		_fileHandle = nil;
	}
	
	int iRetCode = CFHTTPMessageGetResponseStatusCode(response);
	CFRelease(response);
	
    // Check to see if it is a 401 "Authorization Needed" error.  To
    // test for proxy authentication, 407 would have to be caught too.
    if (iRetCode == 401) 
	{
	}
    else if (iRetCode == 200) // OK 
	{
		if(_delegate && [_delegate respondsToSelector:@selector(downloader: finshedDownloadingFile: title: url:)])
		{
			[_delegate downloader:self finshedDownloadingFile: _strDestination title: @"Untitled" url: [_url absoluteString]];
		}
	}
//    else if ((iRetCode == 400) || (iRetCode == 302))
//	{
//		NSURL* finalURL = (NSURL*)CFReadStreamCopyProperty(_stream, kCFStreamPropertyHTTPFinalURL); 
//
//		[_fileHandle release];
//		_fileHandle = nil;
//		[_url release];
//		_url = nil;
//		[_strDownloadedFile release];
//		_strDownloadedFile = nil;
//		if(_request)
//		{
//			CFRelease(_request);
//			_request = nil;
//		}	
//		if(_stream)
//		{
//			CFReadStreamClose(_stream);
//			CFRelease(_stream);
//			_stream = nil;
//		}	
//
//		_bRedirect = NO;
//		[self downloadURL:finalURL delegate: _delegate];
//	}
	
}


- (void)handleStreamError 
{
	//CFStreamError error = CFReadStreamGetError(_stream);	
	//NSLog(@"handleStreamError: Download got stream error with code %d. Retry download.\n",  error.error);
	if(_delegate && [_delegate respondsToSelector:@selector(downloader:failedDownloadingFile:)])
	{
		[_delegate downloader:self failedDownloadingFile: _strDestination];
	}
}

- (void) cancel
{
	if(_stream)
	{
		CFReadStreamSetClient(_stream, 0, NULL, NULL);
		CFReadStreamUnscheduleFromRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		CFReadStreamClose(_stream);
		CFRelease(_stream);
		_stream = NULL;
	}
	
	if(_downloadThread)
	{
		[_downloadThread cancel];
		[_downloadThread release];
		_downloadThread = nil;
	}
	
	if(_fileHandle)
	{
		[_fileHandle closeFile];
		[_fileHandle release];
		_fileHandle = nil;
	}

	if(_strDestination)
	{
		NSFileManager* fileManager = [NSFileManager defaultManager];
		if([fileManager fileExistsAtPath: _strDestination])
		{
			[fileManager removeItemAtPath:_strDestination error:nil];
		}
	}
	
	if(_request)
	{
		CFRelease(_request);
		_request = nil;
	}	

}

- (void) stopDownloading
{
	[self cancel];
}

@end

