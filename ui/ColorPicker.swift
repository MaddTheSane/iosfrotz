//
//  ColorPicker.swift
//  Frotz
//
//  Created by C.W. Betts on 8/26/15.
//
//

import UIKit

private let CGpi = CGFloat(M_PI)

private func RGBtoHSV(r r: CGFloat, g: CGFloat, b: CGFloat, inout h: CGFloat, inout s: CGFloat, inout v: CGFloat) {
    let min = Swift.min(r, g, b)
    let max = Swift.max(r, g, b)
    let delta: CGFloat = max - min
    
    v = max;				// v
    //delta = max - min;
    if max != 0.0 {
        s = delta / max;		// s
    } else { // r,g,b= 0			// s = 0, v is undefined
        s = 0.0;
        h = 0.0; // really -1,
        return;
    }
    if r == max {
        h = (g - b) / delta;		// between yellow & magenta
    } else if g == max {
        h = 2.0 + (b - r) / delta;	// between cyan & yellow
    } else {
        h = 4.0 + (r - g) / delta;	// between magenta & cyan
    }
    h /= 6.0;				// 0 -> 1
    if h < 0.0 {
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
    private var hsvPicker: HSVPicker!
    private var valuePicker: HSVValuePicker!
    private var colorTile: ColorTile!
    private(set) var background: UIView!
    private(set) var tileBorder: UIView!
    private(set) var hsvCursor: UIImageView!
    private(set) var valueCursor: UIImageView!
    
    weak var delegate: ColorPickerDelegate?
    private(set) var hue: CGFloat = 0
    private(set) var saturation: CGFloat = 0
    private(set) var value: CGFloat = 0
    private(set) var colorSpace: CGColorSpace?
    
    private(set) var textColor: UIColor?
    private(set) var bgColor: UIColor?
    private(set) var textColorMode = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = NSLocalizedString("Select Color", comment: "")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = NSLocalizedString("Select Color", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return gLargeScreenDevice ? .All : [.PortraitUpsideDown, .Portrait]
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func loadView() {
        let frame = UIScreen.mainScreen().applicationFrame
        //BOOL fullScreenLarge = (frame.size.width > 760);
        background = UIView(frame: frame)
        self.view = background;
        
        let bgColor = UIColor.whiteColor()
        let borderColor = UIColor.blackColor()
        background.backgroundColor = bgColor
        
        //    [m_background setAutoresizesSubviews: YES];
        background.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let colorTileHeight: CGFloat  = 64.0
        let leftMargin: CGFloat = 8.0
        let hsvBaseYOrigin = colorTileHeight + 64.0;
        let colorTileFrame = CGRect(x: leftMargin, y: 32.0, width: frame.size.width-(leftMargin-1)*2, height: colorTileHeight);
        colorTile = ColorTile(frame: colorTileFrame, colorPicker: self)
        tileBorder = UIView(frame: CGRectInset(colorTileFrame, -1, -1))
        tileBorder.backgroundColor = borderColor
        colorTile.autoresizingMask = [.FlexibleWidth]
        tileBorder.autoresizingMask = [.FlexibleWidth]
        
        let radius: CGFloat = 128.0
        hsvPicker = HSVPicker(frame: CGRect(x: leftMargin, y: hsvBaseYOrigin, width: radius*2, height: radius*2), colorPicker: self)
        valuePicker = HSVValuePicker(frame: CGRect(x: leftMargin+radius*2, y: hsvBaseYOrigin, width: 56.0, height: radius*2), colorPicker: self)
        valuePicker!.barWidth = 32
        
        hsvPicker!.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        valuePicker!.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        valuePicker!.leftMargin = 16
        
        let hsvCursorImage = UIImage(named: "hsv-crosshair")
        hsvCursor = UIImageView(image: hsvCursorImage)
        let valCursorImage = UIImage(named: "val-crosshair")
        valueCursor = UIImageView(image: valCursorImage)
        
        var cursFrame = hsvCursor.frame
        cursFrame.origin = CGPoint(x: radius - 16.0, y: radius - 16.0)
        hsvCursor.frame = cursFrame
        
        cursFrame = valueCursor.frame;
        cursFrame.origin = CGPoint(x: 8, y: -16);
        valueCursor.frame = cursFrame
        
        view.addSubview(tileBorder)
        view.addSubview(hsvPicker)
        view.addSubview(valuePicker)
        view.addSubview(colorTile)
        hsvPicker.addSubview(hsvCursor)
        valuePicker.addSubview(valueCursor)
        
        updateAccessibility()
    }
    
    override func viewWillLayoutSubviews() {
        layoutViews()
    }
    
    private func layoutViews() {
        let frame = self.view.frame;
        let fullScreenLarge = frame.size.width >= 540.0 && frame.size.height >= 576.0
        let isPortrait = UIApplication.sharedApplication().statusBarOrientation == .Portrait
            || UIApplication.sharedApplication().statusBarOrientation == .PortraitUpsideDown
        
        var colorTileHeight: CGFloat  = fullScreenLarge ? 128.0 : isPortrait ? 96.0 : 232.0;
        var leftMargin: CGFloat = fullScreenLarge ? 32.0 : isPortrait ? 4.0 : 16.0;
        var hsvBaseYOrigin = !isPortrait && !fullScreenLarge ? 24.0 : colorTileHeight + 48.0;
        var rightMarin: CGFloat = 60;
        if isPortrait && !fullScreenLarge && frame.size.height > 600 {
            leftMargin += 20;
            colorTileHeight += 60;
            hsvBaseYOrigin += 120;
            rightMarin += 20;
        }
        let colorTileFrame = CGRect(x: leftMargin, y: 24.0,
            width: isPortrait || fullScreenLarge ? frame.size.width-(leftMargin*2-1) : frame.size.width-328,
            height: colorTileHeight);
        if !isPortrait && !fullScreenLarge {
            leftMargin += frame.size.width-312;
        }
        colorTile.frame = colorTileFrame
        tileBorder.frame = CGRectInset(colorTileFrame, -1, -1)
        
        let radius = fullScreenLarge ? frame.size.width/3 : isPortrait ? 128.0 : 116.0;
        if fullScreenLarge {
            hsvPicker.frame = CGRect(x: leftMargin, y: hsvBaseYOrigin, width: radius*2, height: radius*2)
            valuePicker.frame = CGRect(x: frame.size.width - 80.0 - leftMargin, y: hsvBaseYOrigin, width: 96.0, height: radius*2)
            valuePicker.barWidth = 64
        } else {
            hsvPicker.frame = CGRect(x: leftMargin, y: hsvBaseYOrigin, width: radius*2, height: radius*2)
            valuePicker.frame = CGRect(x: frame.size.width - (isPortrait ? rightMarin : 60.0), y: hsvBaseYOrigin, width: 56.0, height: radius*2)
            valuePicker.barWidth = 32
        }
        
        //var cursFrame = valueCursor.frame;
        //    cursFrame.size.width = m_valueCursor.image.size.width * (fullScreenLarge ? 2 : 1);
        //valueCursor.frame = cursFrame
        
        updateHSVCursors()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        layoutViews()
    }
    
    func updateAccessibility() {
        if let colorTile = colorTile {
            colorTile.textLabel?.accessibilityHint = NSLocalizedString("Sample text for color adjustment", comment: "")
        }
    }

    func toggleMode() {
        textColorMode = !textColorMode;
        if textColorMode {
            title = "Text Color";
        } else {
            title = "Background Color";
        }
        updateHSVCursors()
    }
    
    func setTextColor(textColor: UIColor?, bgColor: UIColor?, changeText changeTextColor: Bool) {
        if textColor != nil && self.textColor != textColor! {
            self.textColor = textColor;
        }
        if bgColor != nil && self.bgColor != bgColor {
            self.bgColor = bgColor;
        }
        textColorMode = changeTextColor;
        
        _ = self.view; // force load of view
        if let textColor = textColor {
            colorTile.setTextColor(textColor)
        }
        if let bgColor = bgColor {
            colorTile.setBGColor(bgColor)
        }
        
        if textColor != nil || bgColor != nil {
            updateHSVCursors()
        }
    }
    
    private func updateHSVCursors() {
        let color = textColorMode ? textColor : bgColor;
        let rgba = CGColorGetComponents(color!.CGColor);
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var value: CGFloat = 0
        RGBtoHSV(r: rgba[0], g: rgba[1], b: rgba[2], h: &hue, s: &saturation, v: &value)
        updateColor(hue: hue, saturation: saturation, value: value)
    }
    
    /// doesn't update cursors or callback delegate
    func setColorOnly(color: UIColor) {
        if textColorMode {
            setTextColor(color, bgColor: nil, changeText: textColorMode)
        } else {
            setTextColor(nil, bgColor: color, changeText: textColorMode)
        }
    }
    
    func setColor(color: UIColor) {
        setColorOnly(color)
        let rgba = CGColorGetComponents(color.CGColor)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var value: CGFloat = 0
        RGBtoHSV(r: rgba[0], g: rgba[1], b: rgba[2], h: &hue, s: &saturation, v: &value)
        updateColor(hue: hue, saturation: saturation, value: value)
    }
    
    func setColorValue(color: UIColor) {
        setColorOnly(color)
        let rgba = CGColorGetComponents(color.CGColor)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var value: CGFloat = 0
        RGBtoHSV(r: rgba[0], g: rgba[1], b: rgba[2], h: &hue, s: &saturation, v: &value)
        // keep only changed value
        hue = self.hue;
        saturation = self.saturation;
        updateColor(hue: hue, saturation: saturation, value: value)
    }

    @objc(updateColorWithHue:Saturation:Value:) func updateColor(hue hue: CGFloat, saturation: CGFloat, value: CGFloat) {
        self.hue = !hue.isNaN ? hue : 0
        self.saturation = saturation
        self.value = value
        
        let radius = CGFloat(hsvPicker.width) / 2.0
        let valHeight = CGFloat(valuePicker.height)
        
        var hsvX = radius - 16
        var hsvY = radius - 16
        
        let valX: CGFloat = valuePicker.barWidth > 32 ? 0 : 8
        var valY = CGFloat(-16)
        
        hsvX += (self.saturation * radius) * cos(self.hue * 2 * CGpi)
        hsvY -= (self.saturation * radius) * sin(self.hue * 2 * CGpi)
        valY += (1 - self.value) * valHeight
        
        var cursFrame = hsvCursor.frame
        cursFrame.origin = CGPoint(x: hsvX, y: hsvY)
        hsvCursor.frame = cursFrame
        cursFrame = valueCursor.frame
        cursFrame.origin = CGPoint(x: valX, y: valY)
        valueCursor.frame = cursFrame
        
        valuePicker.setNeedsDisplay()
        
        //    if (oldValue != m_value)
        //	[m_hsvPicker setNeedsDisplay];
        delegate?.colorPicker(self, selectedColor: (textColorMode ? textColor : bgColor)!)
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
    
    @objc override var frame: CGRect {
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
        
        textLabel = UILabel(frame: CGRect(x: 5, y: 5, width: frame.size.width-5, height: frame.size.height-10))
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
        imgView!.frame = CGRect(x: frame.size.width - flipFgImg!.size.width - 1, y: frame.size.height - flipFgImg!.size.height-1, width: flipFgImg!.size.width, height: flipFgImg!.size.height)
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
    
    /*
    var textColor: UIColor? {
        get {
            return textLabel?.textColor
        }
        set {
            textLabel?.textColor = newValue
        }
    }*/
    
    func setTextColor(color: UIColor) {
        textLabel?.textColor = color;
    }
    
    func setBGColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    @objc override var frame: CGRect {
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
    
    init(frame: CGRect, colorPicker: ColorPicker?) {
        self.colorPicker = colorPicker
        super.init(frame: frame)
        self.frame = frame
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, colorPicker: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override var frame: CGRect {
        set {
            if hsvData != nil {
                if width == Int32(newValue.size.width) && height == Int32(newValue.size.height) {
                    super.frame = newValue
                    return
                }
                free(hsvData)
            }
            super.frame = newValue // sets width/height
            
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
                    if dx == 0 {
                        if CGFloat(y) > cy {
                            theta = CGpi + CGpi/2.0;
                        } else {
                            theta = CGpi/2.0;
                        }
                    } else {
                        theta = CGpi - atan(dy/dx);
                        if CGFloat(x) > cx {
                            if CGFloat(y) > cy {
                                theta += CGpi
                            } else {
                                theta -= CGpi
                            }
                        }
                    }
                    s = radius / cx;
                    if s <= 1.0 {
                        h = theta  / (2.0 * CGpi);
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
    
    @objc override func drawRect(rect: CGRect) {
        var h: CGFloat;var s: CGFloat;var v: CGFloat
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        var wColor: UInt32
        var hsv: UInt32
        var i = 0
        
        v = 1.0; //[m_colorPicker value];
        
        var pixelsWide = Int(width)
        var pixelsHigh = Int(height)
        var bitmapBytesPerRow   = (pixelsWide * 4);
        var bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
        
        guard let colorSpace = CGColorSpaceCreateDeviceRGB() else {
            NSLog("Error allocating color space\n");
            return;
        }
        
        var bitmapData = malloc(Int(bitmapByteCount));
        
        guard bitmapData != nil else {
            NSLog("BitmapContext memory not allocated!");
            return;
        }
        defer {
            free(bitmapData)
        }
        let c = UnsafeMutablePointer<UInt32>(bitmapData)
        
        for _ in 0..<height {
            for _ in 0..<width {
                hsv = hsvData[i];
                
                if ((hsv & 0xff000000) != 0) {
                    h = CGFloat((hsv & 0x00ff0000) >> 16) / 255.0;
                    s = CGFloat((hsv & 0x0000ff00) >> 8) / 255.0;
                    HSVtoRGB(r: &r, g: &g, b: &b, h: h, s: s, v: v);
                    
                    wColor = 0xff000000 | ((UInt32(b * 255.0)) << 16) | ((UInt32(g * 255.0)) << 8) | (UInt32(r * 255.0));
                    c[i] = wColor;
                } else {
                    c[i] = 0xffffffff;
                }
                i++;
            }
        }
        
        guard let bmcontext = CGBitmapContextCreate (bitmapData,
            pixelsWide,
            pixelsHigh,
            8,      // bits per component
            bitmapBytesPerRow,
            colorSpace,
            CGImageAlphaInfo.PremultipliedLast.rawValue) else {
                NSLog("Context not created!");
                return;
        }
        
        imageRef = CGBitmapContextCreateImage(bmcontext);
        
        let context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: Int(width), height: Int(height)), imageRef);
        imageRef = nil;
    }
    
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
    
    @objc override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        mousePositionToColor(touch.locationInView(self))
    }
    
    @objc override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        mousePositionToColor(touch.locationInView(self))
    }
    
    @objc override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        //do nothing
    }
    
    @objc override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        mousePositionToColor(touch.locationInView(self))
    }
    
    deinit {
        if hsvData != nil {
            free(hsvData)
            hsvData = nil
        }
    }
}

private class HSVValuePicker : ColorPickerView {
    weak var colorPicker: ColorPicker?
    var leftMargin: Int32 = 0
    var barWidth: Int32 = 0
    var imageRef: CGImage?
    
    init(frame: CGRect, colorPicker: ColorPicker) {
        self.colorPicker = colorPicker
        
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mousePositionToValue(point: CGPoint) {
        let y: Int32
        if point.y < 0 {
            y = 0
        } else if Int32(point.y) >= height {
            y = height
        } else {
            y = Int32(point.y)
        }
        let value: CGFloat = 1 - CGFloat(y) / CGFloat(height)
        
        var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0,0,0,1)
        
        let hue = colorPicker!.hue
        let saturation = colorPicker!.saturation
        HSVtoRGB(r: &rgba.red, g: &rgba.green, b: &rgba.blue, h: hue, s: saturation, v: value);
        
        let color = UIColor(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
        colorPicker?.setColorValue(color) // hue and sat didn't change, so force them constant even if color is black or white
    }
    
    @objc override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        mousePositionToValue(touch.locationInView(self))
    }
    
    @objc override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        mousePositionToValue(touch.locationInView(self))
    }
    
    @objc override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        //Do nothing
    }
    
    @objc override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        mousePositionToValue(touch.locationInView(self))
    }
    
    @objc override func drawRect(rect: CGRect) {
        var bitmapData = UnsafeMutablePointer<()>()
        defer {
            if bitmapData != nil {
                free(bitmapData)
            }
        }
        
        if imageRef == nil {
            var i = 0
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            
            var h: CGFloat = 0
            var s: CGFloat = 0
            var v: CGFloat = 0
            
            let pixelsWide = Int(width)
            let pixelsHigh = Int(height)
            let bitmapBytesPerRow   = pixelsWide * 4
            let bitmapByteCount     = bitmapBytesPerRow * pixelsHigh
            
            guard let colorSpace = CGColorSpaceCreateDeviceRGB() else {
                NSLog("Error allocating color space\n");
                return
            }
            
            bitmapData = malloc(bitmapByteCount);
            guard bitmapData != nil else {
                NSLog("BitmapContext memory not allocated!");
                return;
            }
            let c = UnsafeMutablePointer<UInt32>(bitmapData)
            var wColor: UInt32
            
            h = colorPicker!.hue
            s = colorPicker!.saturation; // use full sat on color picker
            for y in 0..<height {
                var x: Int32 = 0
                for x = 0; x < leftMargin; x++ {
                    c[i++] = 0xffffffff;
                }
                v = CGFloat(y) / CGFloat(height)
                HSVtoRGB(r: &r, g: &g, b: &b, h: h, s: s, v: v);
                // iPhone is little endian, want alpha last in memoryt
                wColor = 0xff000000 | ((UInt32(b * 255.0) & 0xff) << 16) | ((UInt32(g * 255.0) & 0xff) << 8) | ((UInt32(r * 255.0) & 0xff));
                for _ in 0..<barWidth {
                    c[i++] = wColor;
                    x++
                }
                for _ in x..<width {
                    c[i++] = 0xffffffff;
                }
            }
            
            // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
            // per component. Regardless of what the source image format is
            // (CMYK, Grayscale, and so on) it will be converted over to the format
            // specified here by CGBitmapContextCreate.
            guard let bmcontext = CGBitmapContextCreate (bitmapData,
                pixelsWide,
                pixelsHigh,
                8,      // bits per component
                bitmapBytesPerRow,
                colorSpace,
                CGImageAlphaInfo.PremultipliedLast.rawValue) else {
                    NSLog("Context not created!");
                    return
            }
            
            imageRef = CGBitmapContextCreateImage(bmcontext);
        }
        
        let context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: Int(width), height: Int(height)), imageRef);
        imageRef = nil;
    }
}
