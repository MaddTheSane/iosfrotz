//
//  ColorPicker.swift
//  Frotz
//
//  Created by C.W. Betts on 8/26/15.
//
//

import UIKit


private func RGBtoHSV(r r: CGFloat, g: CGFloat, b: CGFloat, inout h: CGFloat, inout s: CGFloat, inout v: CGFloat) {
    var min: CGFloat
    var max: CGFloat
    var delta: CGFloat
    min = Swift.min(r, g)
    min = Swift.min(min, b)
    
    max = Swift.max(r, g)
    max = Swift.max(max, b)
    
    v = max;				// v
    delta = max - min;
    if(max != 0.0) {
        s = delta / max;		// s
    } else { // r,g,b= 0			// s = 0, v is undefined
        s = 0.0;
        h = 0.0; // really -1,
        return;
    }
    if(r == max) {
        h = (g - b) / delta;		// between yellow & magenta
    } else if(g == max) {
        h = 2.0 + (b - r) / delta;	// between cyan & yellow
    } else {
        h = 4.0 + (r - g) / delta;	// between magenta & cyan
    }
    h /= 6.0;				// 0 -> 1
    if(h < 0.0) {
        h += 1.0;
    }
}

private func HSVtoRGB(inout r r: CGFloat, inout g: CGFloat, inout b: CGFloat, h h1: CGFloat, s: CGFloat, v: CGFloat) {
    if s == 0 { // grey
        r = v
        g = v
        b = v
        return
    }
    var h: CGFloat
    if h1 < 0 {
        h = 0
    } else {
        h = h1
    }
    h *= 6
    let sector = Int(h) % 6
    let f = h - CGFloat(sector) // factorial part of h
    let p = v * (1 - s)
    let q = v * (1 - s * f)
    let t = v * (1 - s * (1-f));

    switch sector {
    case 1:
        r = q; g = v; b = p;

    case 2:
        r = p; g = v; b = t;

    case 3:
        r = p; g = q; b = v;

    case 4:
        r = t; g = p; b = v;

    case 5:
        r = v; g = p; b = q;

    default:
        r = v
        g = t
        b = p
    }
}

class ColorPicker: UIViewController {
    
    /*
HSVPicker *m_hsvPicker;
HSVValuePicker *m_valuePicker;
ColorTile *m_colorTile;
UIView *m_background;
UIView *m_tileBorder;
UIImageView *m_hsvCursor;
UIImageView *m_valueCursor;
CGFloat m_hue;
CGFloat m_saturation;
CGFloat m_value;
CGColorSpaceRef m_colorSpace;

UIColor *m_textColor, *m_bgColor;
BOOL m_changeTextColor;
*/
    weak var delegate: ColorPickerDelegate?
    var value: CGFloat = 0
    var textColorMode = false
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    func toggleMode() {
        
    }
    
    func setTextColor(textColor: UIColor, bgColor: UIColor, changeText changeTextColor: Bool) {
        
    }
    
    func updateAccessibility() {
        
    }
    
    func setColor(color: UIColor) {
        
    }
}

private class ColorPickerView: UIView {
    var width: Int32
    var height: Int32
    override init(frame: CGRect) {
        width = Int32(frame.size.width)
        height = Int32(frame.size.height)
        
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        didSet {
            width = Int32(frame.size.width)
            height = Int32(frame.size.height)
        }
    }
}

private class ColorTile: UIView {
    weak var colorPicker: ColorPicker?
    var textLabel: UILabel?
    var imgView: UIImageView?
    var flipFgImg: UIImage?
    var flipBgImg: UIImage?
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, colorPicker: nil)
    }
    
    init(frame: CGRect, colorPicker: ColorPicker?) {
        self.colorPicker = colorPicker
        
        super.init(frame: frame)
        autoresizesSubviews = true
        
        textLabel = UILabel(frame: CGRectMake(5, 5, frame.size.width-5, frame.size.height-10))
        textLabel!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        textLabel!.lineBreakMode = .ByWordWrapping
        textLabel!.backgroundColor = UIColor.clearColor()
        
        if let font = self.colorPicker?.delegate?.fontForColorDemo {
            textLabel!.font = font
        }
        textLabel!.text = "West of House\nThis is an open field west of a white house, with a boarded front door.\nThere is a small mailbox here.\n"
        textLabel!.numberOfLines = 0
        addSubview(textLabel!)
        flipFgImg = UIImage(named: "colorflipfg")
        flipBgImg = UIImage(named: "colorflipbg")
        imgView = UIImageView(image: flipFgImg)
        imgView!.frame = CGRectMake(frame.size.width - flipFgImg!.size.width - 1, frame.size.height - flipFgImg!.size.height-1, flipFgImg!.size.width, flipFgImg!.size.height)
        imgView!.autoresizingMask = [.FlexibleLeftMargin, .FlexibleTopMargin]
        addSubview(imgView!)
        textLabel!.sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func viewDidUnload() {
        textLabel = nil
        imgView = nil;
        flipFgImg = nil;
        flipBgImg = nil;
    }
    
    @objc private override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Do nothing
    }
    
    @objc private override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let pt = touch.locationInView(self)
        if pt.y > bounds.origin.y + bounds.size.height * 0.6 && pt.x > bounds.origin.x + bounds.size.width*0.8 {
            colorPicker?.toggleMode()
            imgView?.image = colorPicker!.textColorMode ? flipFgImg : flipBgImg
        }
    }
    
    @objc private override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        //do nothing
    }
    
    func setTextColor(color: UIColor) {
        textLabel?.textColor = color;
    }
    
    func setBGColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    override var frame: CGRect {
        didSet {
            textLabel?.frame = CGRect(x: 5, y: 5, width: frame.size.width - 5, height: frame.size.height - 5)
            if let font = colorPicker?.delegate?.fontForColorDemo {
                textLabel?.font = font
            }
        }
    }
}

private final class HSVPicker: ColorPickerView {
    weak var colorPicker: ColorPicker?
    var imageRef: CGImage?
    var hsvData: UnsafeMutablePointer<UInt32> = nil
    
    init(frame: CGRect, colorPicker: ColorPicker) {
        self.colorPicker = colorPicker
        super.init(frame: frame)
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        set {
            if hsvData != nil {
                if width == Int32(newValue.size.width) && height == Int32(newValue.size.height) {
                    super.frame = frame
                    return
                }
                free(hsvData)
            }
            super.frame = frame // sets m_width/m_height
            
            let dataSize = sizeof(UInt32) * Int(width * height)
            hsvData = UnsafeMutablePointer<UInt32>(malloc(dataSize))
            
            let cx = CGFloat(width) / 2.0;
            let cy = CGFloat(height) / 2.0;
            
            var h: CGFloat
            var s: CGFloat
            let v: CGFloat = 1
            var i = 0
            
            for var y = height - 1; y >= 0; y-- {
                for x in 0 ..< width {
                    let dx = CGFloat(x) - cx;
                    let dy = CGFloat(y) - cy;
                    let radius = sqrt(dx*dx + dy*dy);
                    var theta: CGFloat
                    if (dx == 0) {
                        if (CGFloat(y) > cy) {
                            theta = CGFloat(M_PI) + CGFloat(M_PI)/2.0;
                        } else {
                            theta = CGFloat(M_PI)/2.0;
                        }
                    } else {
                        theta = CGFloat(M_PI) - atan(dy/dx);
                        if (CGFloat(x) > cx) {
                            if (CGFloat(y) > cy) {
                                theta += CGFloat(M_PI);
                            } else {
                                theta -= CGFloat(M_PI);
                            }
                        }
                    }
                    s = radius / cx;
                    if (s <= 1.0) {
                        h = theta  / (2.0 * CGFloat(M_PI));
                        hsvData[i] = 0xff000000|((((UInt32(h * 255.0)) << 16) | ((UInt32(s * 255.0)) << 8) | (UInt32(v * 255.0))));
                    } else {
                        hsvData[i] = 0x00ffffff;
                    }
                    i++;
                }
            }
        }
        get {
            return super.frame
        }
    }
    
    private override func drawRect(rect: CGRect) {
        
    }
    
    /*
@implementation HSVPicker

- (instancetype) initWithFrame:(CGRect)frame withColorPicker: colorPicker {
if (!(self = [super initWithFrame: frame])) return nil;

m_colorPicker = colorPicker;
[self setFrame: frame];

return self;
}


- (unsigned int *)hsvData {
return m_hsvData;
}

- (void)drawRect:(CGRect)rect {
int x, y, i = 0;
CGFloat r, g, b;
CGFloat h, s, v;

unsigned int wColor, hsv;

v = 1.0; //[m_colorPicker value];

CGContextRef    bmcontext = NULL;
CGColorSpaceRef colorSpace;
void *          bitmapData;
int             bitmapByteCount;
int             bitmapBytesPerRow;

int pixelsWide = m_width, pixelsHigh = m_height;
bitmapBytesPerRow   = (pixelsWide * 4);
bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);

colorSpace = CGColorSpaceCreateDeviceRGB();
if (colorSpace == NULL)
{
NSLog(@"Error allocating color space\n");
return;
}

bitmapData = malloc(bitmapByteCount);

if (bitmapData == NULL)
{
NSLog(@"BitmapContext memory not allocated!");
CGColorSpaceRelease(colorSpace);
return;
}
unsigned int *c = (unsigned int*)bitmapData;

for (y=0; y < m_height; y++)
{
for (x=0; x < m_width; x++) {
hsv = m_hsvData[i];

if ((hsv & 0xff000000UL)) {
h = (CGFloat)((hsv & 0x00ff0000UL) >> 16) / 255.0f;
s = (CGFloat)((hsv & 0x0000ff00UL) >> 8) / 255.0f;
HSVtoRGB(&r, &g, &b, h, s, v);

wColor = 0xff000000UL | (((int)(b * 255.0f)) << 16) | (((int)(g * 255.0f)) << 8) | ((int)(r * 255.0f));
c[i] = wColor;
} else
c[i] = 0xffffffffUL;
i++;
}
}

bmcontext = CGBitmapContextCreate (bitmapData,
pixelsWide,
pixelsHigh,
8,      // bits per component
bitmapBytesPerRow,
colorSpace,
kCGImageAlphaPremultipliedLast);
if (bmcontext == NULL)
{
free (bitmapData);
NSLog(@"Context not created!");
}

// Make sure and release colorspace before returning
CGColorSpaceRelease( colorSpace );

m_imageRef = CGBitmapContextCreateImage(bmcontext);

// When finished, release the context
CGContextRelease(bmcontext);

CGContextRef context = UIGraphicsGetCurrentContext();
CGContextDrawImage(context, CGRectMake(0,0,m_width,m_height), m_imageRef);
CGImageRelease(m_imageRef);
m_imageRef = NULL;
free (bitmapData);

}
*/
    func mousePositionToColor(point: CGPoint) {
        var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0,0,0,1)
        var color: UInt32
        var x = Int32(point.x)
        var y = Int32(point.y)
        if x >= width {
            x = width - 1
        }
        if y >= height {
            y = height - 1
        }
        
        color = hsvData[Int((height-1-y) * width + x)]
        
        let hue = CGFloat((color & 0xff0000) >> 16) / 255
        let saturation = CGFloat((color & 0xff00) >> 8) / 255
        var value = CGFloat((color & 0xff)) / 255
        let alpha = CGFloat((color & 0xff000000) >> 24) / 255
        
        if alpha != 0 {
            value = colorPicker!.value
            HSVtoRGB(r: &rgba.red, g: &rgba.green, b: &rgba.blue, h: hue, s: saturation, v: value)
            let col = UIColor(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
            colorPicker!.setColor(col)
        }
    }
    
    /*
-(void)mousePositionToColor:(CGPoint)point {
unsigned int *c = [self hsvData];
CGFloat rgba[4] = {0.0, 0.0, 0.0, 1.0};
unsigned int color;
unsigned int x = (int)point.x;
unsigned int y = (int)point.y;
if (x >= m_width) x = m_width - 1;
if (y >= m_height) y = m_height - 1;

color = c[(m_height-1-y) * m_width + x];

CGFloat hue = (CGFloat)((color & 0xff0000) >> 16) / 255.0f;
CGFloat saturation = (CGFloat)((color & 0xff00) >> 8) / 255.0f;
CGFloat value; // = (CGFloat)(color & 0xff) / 255.0f;
CGFloat alpha = (CGFloat)((color & 0xff000000) >> 24) / 255.0f;

if (alpha != 0.0f) {
value = [m_colorPicker value];
HSVtoRGB(&rgba[0], &rgba[1], &rgba[2], hue, saturation, value);

UIColor *col = [UIColor colorWithRed: rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]];
[m_colorPicker setColor: col];
}
}
-(void)dealloc {
if (m_hsvData)
free(m_hsvData);
m_hsvData = NULL;
}

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
UITouch* touch = [touches anyObject];
[self mousePositionToColor: [touch locationInView: self]];
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
UITouch* touch = [touches anyObject];
[self mousePositionToColor: [touch locationInView: self]];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
UITouch* touch = [touches anyObject];
[self mousePositionToColor: [touch locationInView: self]];
}
@end
*/
    
    deinit {
        if hsvData != nil {
            free(hsvData)
            hsvData = nil
        }
    }
}

/*
@interface HSVPicker : ColorPickerView {
ColorPicker *m_colorPicker;
CGImageRef m_imageRef;
unsigned int *m_hsvData;
}
- (instancetype) initWithFrame:(CGRect)frame withColorPicker: colorPicker;
@property (nonatomic, readonly) unsigned int *hsvData;
- (void)drawRect:(CGRect)rect;
- (void)mousePositionToColor:(CGPoint)point;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event;
@end
*/
