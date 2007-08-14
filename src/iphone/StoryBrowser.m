/*
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 
 */


#import "StoryBrowser.h"

@implementation StoryBrowser 
- (id)initWithFrame:(struct CGRect)frame withPath: path {
    _path = [[path copy] retain];
    if ((self == [super initWithFrame: frame]) != nil) {
	_storyTable = [[UIPreferencesTable alloc] initWithFrame: CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
	
	m_buttons = [NSArray array];
	m_storyNames = [NSArray array];
	NSString *storyDir = _path;
	NSDirectoryEnumerator *enumerator  = [[NSFileManager defaultManager] enumeratorAtPath:  storyDir];
	id curFile;
	
	while ((curFile = [enumerator nextObject])) {
	    NSString *story = curFile;
	    UIPreferencesTableCell *buttonCell = [[[UIPreferencesTableCell alloc] init] retain];
	    [buttonCell setTitle: story]; 
	    m_buttons = [m_buttons arrayByAddingObject: buttonCell];
	    m_storyNames = [m_storyNames arrayByAddingObject: story];
	    m_numStories++;
	}
	[m_buttons retain];
	[m_storyNames retain];
	
	[_storyTable setDataSource: self];
	[_storyTable setDelegate: self];
	[_storyTable reloadData];
	
	[self addSubview: _storyTable];
    }
    return self;
}

- (NSString *)path {
    return [[_path retain] autorelease];
}

- (void)setPath: (NSString *)path {
    [_path release];
    _path = [path copy];

    [self reloadData];
}

- (void)reloadData {
    [_storyTable reloadData];
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}

- (void)tableRowSelected: (NSNotification*)notif {
    if([_delegate respondsToSelector:@selector(storyBrowser:storySelected:)])
	[_delegate storyBrowser:self storySelected:[self selectedStory]];
}

- (int) numberOfGroupsInPreferencesTable: (id)sender {
    return 1;
}
- (NSString*)preferencesTable:(id)sender titleForGroup:(int)group {
    if (m_numStories > 0)
	return @"Select a Story File";
    else
	return @"No Story Files Found.";		
}
- (int)preferencesTable:(id)sender numberOfRowsInGroup:(int)group {
    return m_numStories;
}
- (id)preferencesTable:(id)sender cellForRow:(int)row inGroup:(int)group {
    if (row >= m_numStories)
	row = 0;
    return [m_buttons objectAtIndex: row];
}

- (NSString *)selectedStory {
    if ([_storyTable selectedRow] == -1)
	return nil;
	
    return [_path stringByAppendingPathComponent: [m_storyNames objectAtIndex: [_storyTable selectedRow]-1]];
}
@end


