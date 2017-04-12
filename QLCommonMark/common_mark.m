//
//  common_mark.m
//  CommonMark QuickLook
//
//  Created by Brett Walker on 4/12/17.
//  Copyright © 2017 digitalMoksha. All rights reserved.
//

#include "shared.h"
#include "common_mark.h"

// Uses the embedded `cmark` command line client
//-----------------------------------------------------------------------------
NSData *render_markdown_cmark(NSURL *url)
{
  NSString *path_to_cmark = [[NSBundle bundleWithIdentifier:kPluginBundleId] pathForResource:kCMark ofType:nil];

  if (kLogDebug) {
    NSLog(@"creating preview for file: %@", [url path]);
    NSLog(@"Using processor:           %@", path_to_cmark);
  }
  
  NSPipe *pipe        = [NSPipe pipe];
  NSFileHandle *file  = pipe.fileHandleForReading;
  NSTask *task        = [[NSTask alloc] init];
  task.launchPath     = [path_to_cmark stringByExpandingTildeInPath];
  task.arguments      = @[url.path];
  task.standardOutput = pipe;
  [task launch];
  
  NSData *data = [file readDataToEndOfFile];
  [file closeFile];

  NSString *html      = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
  NSString *css_dir   = @"~/.cmqlstyle.css";
  NSString *css       = @"";

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
  
  html = [css stringByAppendingString:html];
  html = [NSString stringWithFormat: @"<!DOCTYPE html>\n"
                                      "<html>\n"
                                      "<head>\n"
                                      "  <meta charset=\"utf-8\">\n"
                                      "  <style>\n%@</style>\n"
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
