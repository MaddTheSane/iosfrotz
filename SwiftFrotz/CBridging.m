//
//  CBridging.m
//  Frotz
//
//  Created by C.W. Betts on 8/27/15.
//
//

#import <Foundation/Foundation.h>
#import "iosfrotz.h"
#import "SwiftFrotz-Swift.h"


int iosif_textview_width = kDefaultTextViewMinWidth;
int iosif_textview_height = kDefaultTextViewHeight;
int iosif_screenwidth = 320, iosif_screenheight = 480;
int iosif_fixed_font_width = 5, iosif_fixed_font_height = 10;

int do_autosave = 0, autosave_done = 0, refresh_savedir = 0, restore_frame_count;

NSString *kFixedWidthFontName = @"Courier New";
NSString *kVariableWidthFontName = @"Helvetica";

char SAVE_PATH[MAX_FILE_NAME], AUTOSAVE_FILE[MAX_FILE_NAME];
int ztop_win_height = 1; // hack; for use by frotz terp backend

int currColor = 0, currTextStyle = 0;
BOOL disable_complete = NO;

int lastInputWindow = -1;
int inputsSinceSaveRestore;

char iosif_filename[MAX_FILE_NAME];
char iosif_scriptname[MAX_FILE_NAME];

void iosif_disable_input()
{
	
}

void iosif_enable_input()
{
	
}

void iosif_erase_mainwin()
{
	iosif_erase_win(0);
}

void iosif_enable_tap(int viewNum)
{
	
}

void iosif_disable_tap(int viewNum)
{
	
}

void iosif_enable_single_key_input()
{
	
}

void iosif_erase_screen()
{
	
}

void iosif_erase_win(int winnum)
{
	
}

int iosif_getchar(int timeout)
{
	return 0;
}

void iosif_set_top_win_height(int height)
{
	
	// wait for output to drain so size won't take effect
	// until new output in window
	//iosif_flush(YES);
	
}

void iosif_mark_recent_save()
{
	//inputsSinceSaveRestore = 0;
}

char *iosif_get_temp_filename() {
	char *templateName= strdup([[NSTemporaryDirectory() stringByAppendingPathComponent:@"frotztmp.XXXXXX"] fileSystemRepresentation]);
	char *tempFilename = mktemp(templateName);
	if (!tempFilename) {
		free(templateName);
		return NULL;
	}
	return tempFilename;
}

int iosif_read_file_name(char *file_name, const char *default_name,	int flag)
{
	return 0;
}

int iosif_prompt_file_name (char *file_name, const char *default_name, int flag)
{
	return 0;
}

void iosif_disable_autocompletion()
{
	disable_complete = YES;
}

void iosif_enable_autocompletion()
{
	disable_complete = NO;
}

void iosif_start_script(char *scriptName)
{
	if (scriptName)
		strcpy(iosif_scriptname, scriptName);
	else
		*iosif_scriptname = '\0';
}

void iosif_stop_script()
{
	*iosif_scriptname = '\0';
}

void iosif_putchar(wchar_t c)
{
	iosif_win_putchar(cwin, c);
}

void iosif_win_putchar(int winNum, wchar_t c)
{
	
}

void iosif_puts(char *s) {
	while (*s != '\0')
		iosif_putchar(*s++);
}

void iosif_set_text_attribs(int viewNum, int style, int color, bool lock)
{
	
}
