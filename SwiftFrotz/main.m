//
//  ohai.m
//  Frotz
//
//  Created by C.W. Betts on 8/27/15.
//
//

#import <Cocoa/Cocoa.h>
#include "iosfrotz.h"
#include <locale.h>

int main(int argc, char **argv)
{
    os_init_setup(); // todo: move this into frotz-terp-specific section but called only once
    
    @autoreleasepool {
        
        NSString* resources = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/locale"];
        static char path_locale[1024];
        strcpy(path_locale, [resources cStringUsingEncoding:NSASCIIStringEncoding]);
        setenv("PATH_LOCALE", path_locale, 1);
        setlocale(LC_CTYPE, "en_US.UTF-8");
        
        NSApplicationMain(argc, argv);
    }
    fflush(stdout);
    fflush(stderr);
    
    return 1;
}
