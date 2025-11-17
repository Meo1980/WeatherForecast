//
//  DownloadProcess.m
//  9999Truyen
//
//  Created by bugun on 4/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DownloadProcess.h"
#import "WeatherForecastAppDelegate.h"
#import "HTTPDownloader.h"

@implementation DownloadProcess

@synthesize storyName = _storyName;

- (id)init
{
	self = [super init];
	if(self)
	{
		_storyName = nil;
		_downloader = [[HTTPDownloader alloc] init];
		_iDownloadChapter = - 1;
	}
	
	return self;
}

- (void) startDownloadStory
{
	//[self performSelectorInBackground:@selector(downloadStoryInformationAndPageOne) withObject:nil];
	WeatherForecastAppDelegate* appDelegate = (WeatherForecastAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableDictionary* storyInformation = [appDelegate getInformationFromName:_storyName];
	
	if(![appDelegate.listUsingName containsObject:_storyName])
	{
		NSString* encryptedLink = [storyInformation objectForKey:@"link"];
		NSString* trueLink = encryptedLink;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		int iId = [[storyInformation objectForKey:@"id"] intValue];
		NSString* strStoryPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%d_chapter1.html", iId]];		
		_iDownloadChapter = 1;
		[_downloader downloadURL: [NSURL URLWithString: trueLink] toDestination:strStoryPath delegate: self];
	}

	[self updateProgressUI];
}

- (void) continueDownloadStory
{
//	[self performSelectorInBackground:@selector(downloadStoryProgress) withObject:nil];
	_999TruyenAppDelegate* appDelegate = (_999TruyenAppDelegate*)[[UIApplication sharedApplication] delegate];

	if([appDelegate.listUsingName containsObject:_storyName])
	{
		int iStoryIndex = [appDelegate.listUsingName indexOfObject:_storyName];

		if( _iDownloadChapter < 0)
		{
			if(iStoryIndex >= 0 && iStoryIndex < [appDelegate.listUsingName count])
			{
				_iDownloadChapter = [[appDelegate.listUsingDownloadedChapters objectAtIndex:iStoryIndex] intValue];
			}			
		}
		
		NSMutableArray* chapterList = [[appDelegate.listUsingChapter objectAtIndex:iStoryIndex] mutableCopy];
		if(_iDownloadChapter <= [chapterList count])
		{
			NSDictionary* dict = [chapterList objectAtIndex: _iDownloadChapter - 1];
			NSString* strFullPath = [NSString stringWithFormat: @"http://vnthuquan.net/truyen/%@", [dict objectForKey: @"link"]];

			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			NSNumber* iId = [appDelegate.listUsingID objectAtIndex:iStoryIndex];
			
			NSString* strStoryPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_chapter%d.html", iId, _iDownloadChapter]];
			[_downloader downloadURL: [NSURL URLWithString: strFullPath] toDestination:strStoryPath delegate: self];
		}
	}
	
	[self updateProgressUI];
}

- (void)dealloc
{
	[_downloader release];

	[super dealloc];
}

#if 0
/*- (void) downloadStoryInformationAndPageOne
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	_999TruyenAppDelegate* appDelegate = (_999TruyenAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableDictionary* storyInformation = [appDelegate getInformationFromName:_storyName];
	
	if(![appDelegate.listUsingName containsObject:_storyName])
	{
		NSString* encryptedLink = [storyInformation objectForKey:@"link"];
		
		NSString* trueLink = encryptedLink;
		
		NSURL *url = [NSURL URLWithString: trueLink];
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
		[request setHTTPMethod:@"GET"];
		
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
		if (data == nil) 
		{
			NSLog(@"Error: could not choose vendor");
			[pool release];
			[self performSelectorOnMainThread:@selector(downloadFailed) withObject:nil waitUntilDone:YES];
			return;
		}
		
		NSString *strNewsPapers = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		
		//NSLog(strNewsPapers);
		NSString* strKey;
		NSString* strContent = @"<p align=\"center\" class=\"style28\"><strong>";
		NSString* strValue;
		NSString* strChapterLink;
		NSString* strChapterName;
		NSMutableDictionary* dict;
		NSMutableArray* chapterList = [[NSMutableArray alloc] init];
		int iEndScanner = -1;
		//<acronym title=">
		
		int iChapterNumber = 0;
		
		if(strNewsPapers)
		{	
			NSScanner* scanner = [NSScanner scannerWithString: strNewsPapers];
			BOOL bScan = YES;
			
			strKey = @"<acronym title=\"";
			bScan = [scanner scanUpToString: strKey intoString: NULL];
			if(bScan)
			{
				bScan = [scanner scanUpToString:@"</table>" intoString:NULL];
				if(bScan)
				{
					iEndScanner = [scanner scanLocation];
				}
			}
			[scanner setScanLocation:0];
			
			bScan = YES;
			while(bScan)
			{
				dict = [NSMutableDictionary dictionary];
				strKey = @"<acronym title=\"";
				bScan = [scanner scanUpToString: strKey intoString: NULL];
				if(bScan)
				{
					if([scanner scanLocation] > iEndScanner)
					{
						break;
					}
					
					bScan = [scanner scanUpToString: @"href=\"" intoString: NULL];
					if(bScan)
					{
						[scanner scanString: @"href=\"" intoString: NULL];
						bScan = [scanner scanUpToString: @"\"" intoString: &strChapterLink];
						if(bScan)
						{
							//[data setValue:strChapterLink forKey:@"link"];
							//[chapterList addObject:strChapterLink];
							//NSLog(strChapterLink);
							[scanner scanString:@"\">" intoString:NULL];
							bScan = [scanner scanUpToString:@"<" intoString:&strChapterName];
							if(bScan)
							{
								[dict setValue:[NSNumber numberWithInt:(iChapterNumber+1)] forKey:@"number"];
								[dict setValue:strChapterLink forKey:@"link"];
								[dict setValue:strChapterName forKey:@"name"];
								
								if(iChapterNumber == 0)
								{
									[dict setValue:[NSNumber numberWithBool:YES] forKey:@"downloaded"];
								}
								else
								{
									[dict setValue:[NSNumber numberWithBool:NO] forKey:@"downloaded"];	
								}
								
								iChapterNumber++;
								
								[chapterList addObject:dict];
								
								//NSLog([dict description]);
							}
						}
					}
				}
			}
			
			NSMutableDictionary* storyInformation = [appDelegate getInformationFromName:_storyName];
			
			[appDelegate.listUsingAuthor addObject:[storyInformation objectForKey:@"author"]];
			[appDelegate.listUsingType addObject:[storyInformation objectForKey:@"kind"]];
			[appDelegate.listUsingID addObject:[storyInformation objectForKey:@"id"]];
			[appDelegate.listUsingFirstLink addObject:[storyInformation objectForKey:@"link"]];
			[appDelegate.listUsingName addObject:_storyName];
			[appDelegate.listUsingReadingChapter addObject:[NSNumber numberWithInt:0]];
			[appDelegate.listUsingDownloadedChapters addObject:[NSNumber numberWithInt:1]];
			if([chapterList count] > 0)
			{
				[appDelegate.listUsingChapter addObject:chapterList];
			}
			else
			{
				dict = [NSMutableDictionary dictionary];
				[dict setValue:[NSNumber numberWithInt:1] forKey:@"number"];
				[dict setValue:trueLink forKey:@"link"];
				[dict setValue:_storyName forKey:@"name"];
				[dict setValue:[NSNumber numberWithBool:YES] forKey:@"downloaded"];
				[chapterList addObject:dict];
				[appDelegate.listUsingChapter addObject:chapterList];
			}
			
			[self performSelectorOnMainThread:@selector(updateProgressUI) withObject:nil waitUntilDone: YES];
			//if(_nameViewControllerDelegate)
//			{
//				[_nameViewControllerDelegate reloadStoryListTableData];
//			}
//			if(_artistViewControllerDelegate)
//			{
//				[_artistViewControllerDelegate reloadStoryListTableData];
//			}
//			if(_typeViewControllerDelegate)
//			{
//				[_typeViewControllerDelegate reloadStoryListTableData];
//			}
//			if(_favouriteViewControllerDelegate)
//			{
//				[_favouriteViewControllerDelegate reloadStoryListTableData];
//			}
			
			[scanner setScanLocation:0];
			
			strKey = strContent;
			bScan = [scanner scanUpToString: strKey intoString: NULL];
			if(bScan)
			{
				[scanner scanString: strKey intoString: NULL];
				
				bScan = [scanner scanUpToString: @"</div>" intoString: &strValue];
				if(bScan)
				{
					strContent = [NSString stringWithFormat:@"%@%@", strContent, strValue];
					//NSLog(strContent);
				}
			}
			
			
		}
		
		if(strContent)
		{

			// Write the story to file
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			int iId = [[storyInformation objectForKey:@"id"] intValue];
			NSString* strStoryPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%d_chapter1.html", iId]];
			[self writeContentOfFile:strContent fileName:strStoryPath];
			[self downloadStoryProgress];
		}
		[pool release];
	}
}

- (void) downloadStoryProgress
{
	int loop;
	_999TruyenAppDelegate* appDelegate = (_999TruyenAppDelegate*)[[UIApplication sharedApplication] delegate];
	int iStoryIndex = [appDelegate.listUsingName indexOfObject:_storyName];
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	if(iStoryIndex >= 0 && iStoryIndex < [appDelegate.listUsingName count])
	{
		NSMutableArray* chapterList = [[appDelegate.listUsingChapter objectAtIndex:iStoryIndex] mutableCopy];
		
		int iStartingNumber = [[appDelegate.listUsingDownloadedChapters objectAtIndex:iStoryIndex] intValue];
		
		int iId = [[appDelegate.listUsingID objectAtIndex:iStoryIndex] intValue];
		
		for (loop = iStartingNumber; loop < [chapterList count] && _bDownload; loop ++)
		{
			NSMutableDictionary* dict = [[chapterList objectAtIndex:loop] mutableCopy];
			NSString* strFullPath = [NSString stringWithFormat: @"http://vnthuquan.net/truyen/%@", [dict objectForKey: @"link"]];
			NSURL *url = [NSURL URLWithString: strFullPath];
			
			NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
			[request setHTTPMethod:@"GET"];
			
			NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
			if (data == nil) 
			{
				NSLog(@"Error: could not get data");
				[pool release];
				[self performSelectorOnMainThread:@selector(downloadFailed) withObject:nil waitUntilDone:YES];
				break;
			}
			
			NSString *strNewsPapers = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
			
			NSString* strContent;
			NSString* strValue;
			NSString* strStoryPath;
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			if(strNewsPapers)
			{	
				NSScanner* scanner = [NSScanner scannerWithString: strNewsPapers];
				BOOL bScan = YES;
				if(bScan)
				{
					strContent = @"<p align=\"center\" class=\"style28\"><strong>";
					NSString* strKey = strContent;
					bScan = [scanner scanUpToString: strKey intoString: NULL];
					if(bScan)
					{
						[scanner scanString: strKey intoString: NULL];
						
						bScan = [scanner scanUpToString: @"</div>" intoString: &strValue];
						if(bScan)
						{
							strContent = [NSString stringWithFormat:@"%@%@", strContent, strValue];
							strStoryPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%d_chapter%d.html", iId, loop + 1]];
							[self writeContentOfFile:strContent fileName:strStoryPath];

							[dict setObject:[NSNumber numberWithBool:YES] forKey:@"downloaded"];
							[chapterList replaceObjectAtIndex:loop withObject:dict];
							[appDelegate.listUsingDownloadedChapters replaceObjectAtIndex:iStoryIndex withObject:[NSNumber numberWithInt:loop+1]];
						}
					}
				}
				if(loop == [chapterList count] - 1)
				{
					int iChapterNumber = 0;
					NSString* strKey = nil;
					int iEndScanner = -1;
					NSString* strChapterLink;
					NSString* strChapterName;
					
					[scanner setScanLocation:0];
					strKey = @"<acronym title=\"";
					bScan = [scanner scanUpToString: strKey intoString: NULL];
					if(bScan)
					{
						bScan = [scanner scanUpToString:@"</table>" intoString:NULL];
						if(bScan)
						{
							iEndScanner = [scanner scanLocation];
						}
					}
					
					[scanner setScanLocation:0];
					bScan = YES;
					while(bScan)
					{
						dict = [NSMutableDictionary dictionary];
						strKey = @"<acronym title=\"";
						bScan = [scanner scanUpToString: strKey intoString: NULL];
						if(bScan)
						{
							if([scanner scanLocation] > iEndScanner)
							{
								break;
							}
							
							bScan = [scanner scanUpToString: @"href=\"" intoString: NULL];
							if(bScan)
							{
								[scanner scanString: @"href=\"" intoString: NULL];
								bScan = [scanner scanUpToString: @"\"" intoString: &strChapterLink];
								if(bScan)
								{
									//[data setValue:strChapterLink forKey:@"link"];
									//[chapterList addObject:strChapterLink];
									//NSLog(strChapterLink);
									[scanner scanString:@"\">" intoString:NULL];
									bScan = [scanner scanUpToString:@"<" intoString:&strChapterName];
									if(bScan)
									{
										[dict setValue:[NSNumber numberWithInt:(iChapterNumber+1)] forKey:@"number"];
										[dict setValue:strChapterLink forKey:@"link"];
										[dict setValue:strChapterName forKey:@"name"];
										
										if(iChapterNumber == 0)
										{
											[dict setValue:[NSNumber numberWithBool:YES] forKey:@"downloaded"];
										}
										else
										{
											[dict setValue:[NSNumber numberWithBool:NO] forKey:@"downloaded"];	
										}
										
										iChapterNumber++;
										
										if(iChapterNumber > [chapterList count])
										{
											[chapterList addObject:dict];
										}
										
										//NSLog([dict description]);
									}
								}
							}
						}
					}
				}
			}
			
			[self performSelectorOnMainThread:@selector(updateProgressUI) withObject:nil waitUntilDone: YES];
//			if(_nameViewControllerDelegate)
//			{
//				[_nameViewControllerDelegate reloadStoryListTableData];
//			}
//			if(_artistViewControllerDelegate)
//			{
//				[_artistViewControllerDelegate reloadStoryListTableData];
//			}
//			if(_typeViewControllerDelegate)
//			{
//				[_typeViewControllerDelegate reloadStoryListTableData];
//			}
//			if(_favouriteViewControllerDelegate)
//			{
//				[_favouriteViewControllerDelegate reloadStoryListTableData];
//			}
		}
		
		[appDelegate.listUsingChapter replaceObjectAtIndex:iStoryIndex withObject:chapterList];
		[self performSelectorOnMainThread:@selector(updateProgressUI) withObject:nil waitUntilDone: YES];
		
		//		ReadStoryViewController* controller = [[ReadStoryViewController alloc] initWithNibName:@"ReadStoryViewController" bundle:nil];
		//		controller.iStoryID = iId;
		//		[self.navigationController pushViewController:controller animated:YES];
		//		[controller release];
		[appDelegate.listDownloadingProcess removeObject:self];
		[pool release];
	}
}*/
#endif

- (void) updateProgressUI
{
	NSNotification* notification = [NSNotification notificationWithName:@"updateDownloadProgressForStory" object:_storyName];
	[[NSNotificationCenter defaultCenter] postNotification: notification];
}

- (void) downloadFailed
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
													message:@"Xuất hiện lỗi trong quá trình download, bạn hãy kiểm tra lại kết nối mạng hoặc thử lại sau"
												   delegate:self
													cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	_999TruyenAppDelegate* appDelegate = (_999TruyenAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate.listDownloadingProcess removeObject:self];
}

/*- (NSString*) convertLink:(NSString *)encriptedString
{
	NSString* oriString = encriptedString;
	NSString* lastString = @"http://vnthuquan.net/truyen/truyen.aspx?tid=2qtqv3m3237n";
	int iNumber = [oriString length] - 23;
	int loop;
	char character;
	for (loop = 0; loop < iNumber; loop++) {
		if(loop >= 28 && loop < iNumber)
		{
			character = [oriString characterAtIndex:loop];
			if(loop % 2)
			{
				character += 5;
			}
			else {
				character -= 5;
			}
			
			lastString = [NSString stringWithFormat:@"%@%c", lastString, character];
		}
	}
	
	lastString = [NSString stringWithFormat:@"%@n31n343tq83a3q3m3237nvn",lastString];
	
	return lastString;
}*/

- (void) writeContentOfFile: (NSString*) strContent fileName: (NSString*) fileName
{
	NSMutableString* strFinalContent = [NSMutableString string];
	NSString* strStoreContent = @"";
	NSString* strCheck = @"";
	
	NSScanner* scanner = [NSScanner scannerWithString: strContent];
	[scanner setCaseSensitive:NO];
	BOOL bScan = YES;
	
	bScan = [scanner scanUpToString:@"</table>" intoString:&strStoreContent];
	if(bScan)
	{
		[strFinalContent appendString: strStoreContent];
	}
	bScan = [scanner scanString:@"</table>" intoString:&strStoreContent];
	[strFinalContent appendString:@"</table>"];
	
	while(bScan)
	{
		bScan = [scanner scanUpToString: @"<" intoString: &strStoreContent];
		if(bScan)
		{
			//strFinalContent = [strFinalContent stringByAppendingString:strStoreContent];
			[strFinalContent appendString: strStoreContent];
		}
		else 
		{
			bScan = [scanner scanString:@"<" intoString:nil];
		}

		if(bScan)
		{
			bScan = [scanner scanUpToString:@">" intoString:&strCheck];
			if(bScan)
			{
				[scanner scanString:@">" intoString:nil];
				strCheck = [strCheck stringByAppendingString:@">"];
				NSRange range = [strCheck rangeOfString:@"br>" options:NSCaseInsensitiveSearch];
				if (range.length > 0) 
				{
					//strFinalContent = [strFinalContent stringByAppendingString:@"\n"];
					[strFinalContent appendString: @"\n"];
				}
				range = [strCheck rangeOfString:@"p>" options:NSCaseInsensitiveSearch];
				if(range.length > 0)
				{
					//strFinalContent = [strFinalContent stringByAppendingString:@"\n"];
					[strFinalContent appendString: @"\n"];
				}
				
				range = [strCheck rangeOfString:@"br " options:NSCaseInsensitiveSearch];
				if (range.length > 0) 
				{
					//strFinalContent = [strFinalContent stringByAppendingString:@"\n"];
					[strFinalContent appendString: @"\n"];
				}
				range = [strCheck rangeOfString:@"p " options:NSCaseInsensitiveSearch];
				if(range.length > 0)
				{
					//strFinalContent = [strFinalContent stringByAppendingString:@"\n"];
					[strFinalContent appendString: @"\n"];
				}
			}
		}
	}
	
	int iCurrentPosition = [scanner scanLocation];
	
	strStoreContent = [strContent substringFromIndex:iCurrentPosition];
	
	//strFinalContent = [strFinalContent stringByAppendingString:strStoreContent];
	[strFinalContent appendString: strStoreContent];

	
	NSRange range;
	range.location = 0;
	range.length = [strFinalContent length];
	
	//strFinalContent = [strFinalContent stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" " options:NSCaseInsensitiveSearch range:range];
	[strFinalContent replaceOccurrencesOfString: @"&nbsp;" withString:@" " options:NSCaseInsensitiveSearch range:range];
	
	range.length = [strFinalContent length];
	
	//strFinalContent = [strFinalContent stringByReplacingOccurrencesOfString:@"&bull;" withString:@"*" options:NSCaseInsensitiveSearch range:range];
	[strFinalContent replaceOccurrencesOfString: @"&bull;" withString:@"*" options:NSCaseInsensitiveSearch range:range];
	
	range.length = [strFinalContent length];
	
	//strFinalContent = [strFinalContent stringByReplacingOccurrencesOfString:@"frasl;" withString:@"/" options:NSCaseInsensitiveSearch range:range];
	[strFinalContent replaceOccurrencesOfString: @"&frasl;" withString:@"/" options:NSCaseInsensitiveSearch range:range];
	
		[strFinalContent replaceOccurrencesOfString: @"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:range];
		
	NSString* trimString = [strFinalContent stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"\t\n"]];
	[trimString writeToFile: fileName atomically: YES]; 
	
}

- (void) stopDownloading
{
	if(_downloader)
	{
		[_downloader stopDownloading];
	}

	_999TruyenAppDelegate* appDelegate = (_999TruyenAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate.listDownloadingProcess removeObject:self];
	[self updateProgressUI];
}

#pragma mark HTTPDownloader delegate

- (void) downloader:(HTTPDownloader*) downloader finshedDownloadingFile: (NSString*) file title: (NSString*) title url: (NSString*) url
{
	_999TruyenAppDelegate* appDelegate = (_999TruyenAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSData* data = [NSData dataWithContentsOfFile: file];
	NSString *strNewsPapers = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
	
	NSString* strKey;
	NSString* strContent = @"<p align=\"center\" class=\"style28\"><strong>";
	NSString* strValue;
	NSString* strChapterLink;
	NSString* strChapterName;
	NSMutableDictionary* dict;
	NSMutableArray* chapterList = [[NSMutableArray alloc] init];
	int iEndScanner = -1;
	//<acronym title=">
	
	int iChapterNumber = 0;
	
	if(strNewsPapers)
	{	
		NSScanner* scanner = [NSScanner scannerWithString: strNewsPapers];
		BOOL bScan = YES;
		
		strKey = @"<acronym title=\"";
		bScan = [scanner scanUpToString: strKey intoString: NULL];
		if(bScan)
		{
			bScan = [scanner scanUpToString:@"</table>" intoString:NULL];
			if(bScan)
			{
				iEndScanner = [scanner scanLocation];
			}
		}
		[scanner setScanLocation:0];
		
		if(_iDownloadChapter == 1)
		{
			bScan = YES;
			while(bScan)
			{
				dict = [NSMutableDictionary dictionary];
				strKey = @"<acronym title=\"";
				bScan = [scanner scanUpToString: strKey intoString: NULL];
				if(bScan)
				{
					if([scanner scanLocation] > iEndScanner)
					{
						break;
					}
					
					bScan = [scanner scanUpToString: @"href=\"" intoString: NULL];
					if(bScan)
					{
						[scanner scanString: @"href=\"" intoString: NULL];
						bScan = [scanner scanUpToString: @"\"" intoString: &strChapterLink];
						if(bScan)
						{
							[scanner scanString:@"\">" intoString:NULL];
							bScan = [scanner scanUpToString:@"<" intoString:&strChapterName];
							if(bScan)
							{
								[dict setValue:[NSNumber numberWithInt:(iChapterNumber+1)] forKey:@"number"];
								[dict setValue:strChapterLink forKey:@"link"];
								[dict setValue:strChapterName forKey:@"name"];
								
								if(iChapterNumber == 0)
								{
									[dict setValue:[NSNumber numberWithBool:YES] forKey:@"downloaded"];
								}
								else
								{
									[dict setValue:[NSNumber numberWithBool:NO] forKey:@"downloaded"];	
								}
								
								iChapterNumber++;
								
								[chapterList addObject:dict];
								
							}
						}
					}
				}
			}
			NSMutableDictionary* storyInformation = [appDelegate getInformationFromName:_storyName];
			
			[appDelegate.listUsingAuthor addObject:[storyInformation objectForKey:@"author"]];
			[appDelegate.listUsingType addObject:[storyInformation objectForKey:@"kind"]];
			[appDelegate.listUsingID addObject:[storyInformation objectForKey:@"id"]];
			[appDelegate.listUsingFirstLink addObject:[storyInformation objectForKey:@"link"]];
			[appDelegate.listUsingName addObject:_storyName];
			[appDelegate.listUsingReadingChapter addObject:[NSNumber numberWithInt:0]];
			[appDelegate.listUsingDownloadedChapters addObject:[NSNumber numberWithInt:1]];
			if([chapterList count] > 0)
			{
				[appDelegate.listUsingChapter addObject:chapterList];
			}
			else
			{
				dict = [NSMutableDictionary dictionary];
				[dict setValue:[NSNumber numberWithInt:1] forKey:@"number"];
				[dict setValue:url forKey:@"link"];
				[dict setValue:_storyName forKey:@"name"];
				[dict setValue:[NSNumber numberWithBool:YES] forKey:@"downloaded"];
				[chapterList addObject:dict];
				[appDelegate.listUsingChapter addObject:chapterList];
			}
		}
		else 
		{
			int iStoryIndex = [appDelegate.listUsingName indexOfObject:_storyName];
			NSMutableArray* chapterList = [[appDelegate.listUsingChapter objectAtIndex:iStoryIndex] mutableCopy];
			//int iId = [[appDelegate.listUsingID objectAtIndex:iStoryIndex] intValue];
			NSMutableDictionary* dict = [[chapterList objectAtIndex:_iDownloadChapter - 1] mutableCopy];
				
			//NSString* strContent;
			//NSString* strValue;
			//NSString* strStoryPath;
			//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			//NSString *documentsDirectory = [paths objectAtIndex:0];
				
				if(strNewsPapers)
				{	
					NSScanner* scanner = [NSScanner scannerWithString: strNewsPapers];
					BOOL bScan = YES;
					if(bScan)
					{
						strContent = @"<p align=\"center\" class=\"style28\"><strong>";
						NSString* strKey = strContent;
						bScan = [scanner scanUpToString: strKey intoString: NULL];
						if(bScan)
						{
							[scanner scanString: strKey intoString: NULL];
							
							bScan = [scanner scanUpToString: @"</div>" intoString: &strValue];
							if(bScan)
							{
								strContent = [NSString stringWithFormat:@"%@%@", strContent, strValue];
								
								[dict setObject:[NSNumber numberWithBool:YES] forKey:@"downloaded"];
								[chapterList replaceObjectAtIndex:_iDownloadChapter - 1 withObject:dict];
								[appDelegate.listUsingDownloadedChapters replaceObjectAtIndex:iStoryIndex withObject:[NSNumber numberWithInt: _iDownloadChapter]];
							}
						}
					}
					if(_iDownloadChapter == [chapterList count])
					{
						int iChapterNumber = 0;
						NSString* strKey = nil;
						int iEndScanner = -1;
						NSString* strChapterLink;
						NSString* strChapterName;
						
						[scanner setScanLocation:0];
						strKey = @"<acronym title=\"";
						bScan = [scanner scanUpToString: strKey intoString: NULL];
						if(bScan)
						{
							bScan = [scanner scanUpToString:@"</table>" intoString:NULL];
							if(bScan)
							{
								iEndScanner = [scanner scanLocation];
							}
						}
						
						[scanner setScanLocation:0];
						bScan = YES;
						while(bScan)
						{
							dict = [NSMutableDictionary dictionary];
							strKey = @"<acronym title=\"";
							bScan = [scanner scanUpToString: strKey intoString: NULL];
							if(bScan)
							{
								if([scanner scanLocation] > iEndScanner)
								{
									break;
								}
								
								bScan = [scanner scanUpToString: @"href=\"" intoString: NULL];
								if(bScan)
								{
									[scanner scanString: @"href=\"" intoString: NULL];
									bScan = [scanner scanUpToString: @"\"" intoString: &strChapterLink];
									if(bScan)
									{
										//[data setValue:strChapterLink forKey:@"link"];
										//[chapterList addObject:strChapterLink];
										//NSLog(strChapterLink);
										[scanner scanString:@"\">" intoString:NULL];
										bScan = [scanner scanUpToString:@"<" intoString:&strChapterName];
										if(bScan)
										{
											[dict setValue:[NSNumber numberWithInt:(iChapterNumber+1)] forKey:@"number"];
											[dict setValue:strChapterLink forKey:@"link"];
											[dict setValue:strChapterName forKey:@"name"];
											
											if(iChapterNumber == 0)
											{
												[dict setValue:[NSNumber numberWithBool:YES] forKey:@"downloaded"];
											}
											else
											{
												[dict setValue:[NSNumber numberWithBool:NO] forKey:@"downloaded"];	
											}
											
											iChapterNumber++;
											
											if(iChapterNumber > [chapterList count])
											{
												[chapterList addObject:dict];
											}
											
											//NSLog([dict description]);
										}
									}
								}
							}
						}
					}
				}
				
			
			[appDelegate.listUsingChapter replaceObjectAtIndex:iStoryIndex withObject:chapterList];
			
		}

		[self updateProgressUI];
		
		[scanner setScanLocation:0];
		
		strKey = strContent;
		bScan = [scanner scanUpToString: strKey intoString: NULL];
		if(bScan)
		{
			[scanner scanString: strKey intoString: NULL];
			
			bScan = [scanner scanUpToString: @"</div>" intoString: &strValue];
			if(bScan)
			{
				strContent = [NSString stringWithFormat:@"%@%@", strContent, strValue];
				//NSLog(strContent);
			}
		}
		
		
	}
	
	if(strContent)
	{
		[strNewsPapers release];

		// Re_write the story to file
		[self writeContentOfFile:strContent fileName: file];
		
		// Download next chapter
		_iDownloadChapter ++;
	
		int iStoryIndex = [appDelegate.listUsingName indexOfObject:_storyName];
		NSMutableArray* chapterList = [[appDelegate.listUsingChapter objectAtIndex:iStoryIndex] mutableCopy];
		if(_iDownloadChapter <= [chapterList count])
		{
			[self continueDownloadStory];
		}
		else if(_iDownloadChapter > [chapterList count])
		{
			[self updateProgressUI];
			[appDelegate.listDownloadingProcess removeObject:self];
		}
	}

	
	
}

- (void) downloader:(HTTPDownloader*) downloader failedDownloadingFile: (NSString*) file
{
	_999TruyenAppDelegate* appDelegate = (_999TruyenAppDelegate*)[[UIApplication sharedApplication] delegate];
	[self updateProgressUI];
	
	[_downloader release];
	_downloader = nil;
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Thông Tin" message: @"Lỗi xảy ra trong quá trình tải truyện. Hãy kiểm tra kết nối mạng của bạn." delegate: nil cancelButtonTitle: @"Đóng" otherButtonTitles: nil];
	[alert show];
	[alert release];

	[appDelegate.listDownloadingProcess removeObject:self];
}

@end
