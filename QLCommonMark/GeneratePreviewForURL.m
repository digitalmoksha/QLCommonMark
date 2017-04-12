#include "shared.h"
#include "common_mark.h"

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
 Generate a preview for file
 
 This function's job is to create preview for designated file
 ----------------------------------------------------------------------------- */

//-----------------------------------------------------------------------------
OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
  NSURL *nsurl = (__bridge NSURL *)url;
  
  if (kLogDebug) NSLog(@"generate preview for content type: %@", contentTypeUTI);
  
  CFDataRef previewData;
  
  if (CFStringCompare(contentTypeUTI, CFSTR("org.textbundle.package"), 0) == kCFCompareEqualTo)
  {
    NSString *docPath = [[nsurl path] stringByAppendingPathComponent:@"text.md"];
    nsurl             = [NSURL fileURLWithPath:docPath];
  }
  previewData = (__bridge CFDataRef)render_markdown_cmark(nsurl);
  
  if (previewData)
  {
    if (kLogDebug) NSLog(@"preview generated");
    
    CFDictionaryRef properties = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObject:@"UTF-8" forKey:(NSString *)kQLPreviewPropertyTextEncodingNameKey];
    QLPreviewRequestSetDataRepresentation(preview, previewData, kUTTypeHTML, properties);
  }
  
  return noErr;
}

//-----------------------------------------------------------------------------
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
  // Implement only if supported
}


