//
//  common_mark.m
//  CommonMark QuickLook
//
//  Created by Brett Walker on 4/12/17.
//  Copyright © 2017 digitalMoksha. All rights reserved.
//

#include "shared.h"
#include "common_mark.h"
#include "cmark/cmark.h"

// Uses the embedded `cmark` command line client
//-----------------------------------------------------------------------------
NSData *render_markdown_cmark(NSURL *url)
{
  if (kLogDebug) NSLog(@"creating preview for file: %@", [url path]);
  
  NSString *css_dir   = @"~/.cmqlstyle.css";
  NSString *css       = @"";
  NSString *md        = [NSString stringWithContentsOfFile: url.path encoding: NSUTF8StringEncoding error: NULL];
  char *html_c_string = cmark_markdown_to_html([md UTF8String], [md lengthOfBytesUsingEncoding:NSUTF8StringEncoding], CMARK_OPT_DEFAULT);
  NSString *html      = [[NSString alloc] initWithUTF8String:html_c_string];
  free(html_c_string);

  if (kLogDebug) NSLog(@"Converted Data: %@", html);

  if ([[NSFileManager defaultManager] fileExistsAtPath:[css_dir stringByExpandingTildeInPath]])
  {
    css = [NSString stringWithFormat:@"\n<style>body{-webkit-font-smoothing:antialiased;padding:20px;max-width:900px;margin:0 auto;}%@</style>", [NSString stringWithContentsOfFile:[css_dir stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil]];
    if (kLogDebug) NSLog(@"Using styles found in ~/.cmqlstyle.css: %@", css);
  }
  else
  {
    NSString *contents        = @"";
    NSString *bootstrap_path  = [NSString stringWithFormat: @"%@/%@/", [[NSBundle bundleWithIdentifier:kPluginBundleId] resourcePath], @"themes/bootstrap/css"];
    css = @"";
    
    if (kLogDebug) NSLog(@"Using internal style");
    
    contents = [NSString stringWithContentsOfFile:[NSString stringWithFormat: @"%@/%@", bootstrap_path, @"bootstrap.min.css"]
                                                  encoding:NSUTF8StringEncoding error:nil];
    css = [css stringByAppendingFormat: @"<style>%@</style>\n", contents];
    contents = [NSString stringWithContentsOfFile:[NSString stringWithFormat: @"%@/%@", bootstrap_path, @"bootstrap-theme.min.css"]
                                                  encoding:NSUTF8StringEncoding error:nil];
    css = [css stringByAppendingFormat: @"<style>%@</style>\n", contents];
    contents = [NSString stringWithContentsOfFile:[NSString stringWithFormat: @"%@/%@", bootstrap_path, @"bootstrap-theme.min.custom.css"]
                                         encoding:NSUTF8StringEncoding error:nil];
    css = [css stringByAppendingFormat: @"<style>%@</style>\n", contents];
    contents = [NSString stringWithContentsOfFile:[NSString stringWithFormat: @"%@/%@", bootstrap_path, @"custom.min.css"]
                                         encoding:NSUTF8StringEncoding error:nil];
    css = [css stringByAppendingFormat: @"<style>%@</style>\n", contents];

  }
  
  html = [NSString stringWithFormat: @"<!DOCTYPE html>\n"
                                      "<html>\n"
                                      "<head>\n"
                                      "  <meta charset=\"utf-8\">\n"
                                      "  %@\n"
                                      "  <base href=\"%@\"/>\n"
                                      "</head>\n"
                                      "<body>\n"
                                      "  <div class=\"container-fluid\">\n"
                                      "    <div class=\"row\">\n"
                                      "      <div class=\"col-sm-12\" id=\"content_body\">\n"
                                      "%@"
                                      "      </div>\n"
                                      "    </div>\n"
                                      "  </div>\n"
                                      "</body>\n"
                                      "</html>",
                                      css, url, html];

  if (kLogDebug) NSLog(@"Rendered Data: %@", html);
  
  return [html dataUsingEncoding:NSUTF8StringEncoding];
}
