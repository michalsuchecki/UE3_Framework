class GameMenuLabel extends GameMenuObject;

struct STextLine
{
    var string Caption;
    var Vector2D Position;
    var int LineNumber;

    structdefaultproperties
    {
        Caption=""
        Position=(X=0.0,Y=0.0)
        LineNumber=0
    }
};

var Font TextFont;
var Color DefaultTextColor;
var Color TextColor;
var float textscale;
var EAlign TextAlign;
var float ScreenScale;
var bool bScaleSet;
var bool bGetScaleFromObject;
var Vector2D TextPadding;
var Vector2D CurTextPadding;
var float LinePadding;
var float LinePaddingPx;
var array<STextLine> TextLines;
var string Caption;

function InitMenuObject(MobilePlayerInput PlayerInput, MobileMenuScene Scene, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
    super.InitMenuObject(PlayerInput, Scene, ScreenWidth, ScreenHeight, bIsFirstInitialization);
    ScreenScale = ((bGetScaleFromObject) ? Height / 1080.0 : Scene.Height / 1080.0);
    DefaultTextColor = TextColor;

    if(bIsFirstInitialization)
    {
        CurTextPadding.X = TextPadding.X * Width;
        CurTextPadding.Y = TextPadding.Y * Height;
    }
    SetCaption(Caption);
}

function SetScale(Canvas C)
{
    local STextLine TextDesc;
    local array<string> TLines;
    local float TX, TY;
    local int StartOffsetX, StartOffsetY, TotalCaptionHeight, LineNr, I;

    local string ParseText;

    TextLines.Length = 0;
    LineNr = 0;
    TotalCaptionHeight = 0;
    ParseStringIntoArray(Caption, TLines, "\\n", true);

    foreach TLines(ParseText, I)
    {
        ParseText = Repl(ParseText, "\\n", "", false);

        if(Len(ParseText) > 0)
        {
            C.TextSize(ParseText, TX, TY, textscale * ScreenScale, textscale * ScreenScale);
            LinePaddingPx = TY * LinePadding;
            switch(TextAlign)
            {
                case 0:
                case 3:
                case 6:
                    StartOffsetX = 0;
                    break;
                case 1:
                case 4:
                case 7:
                    StartOffsetX = int((Width - TX) / float(2));
                    break;
                case 2:
                case 5:
                case 8:
                    StartOffsetX = int((Width - TX) - float(1));
                    break;
                default:
                    TextDesc.Caption = ParseText;
                    TotalCaptionHeight += int(TY);
                    TextDesc.Position.Y = (Top + CurTextPadding.Y) + (float(LineNr) * TY);
                    TextDesc.Position.X = (Left + CurTextPadding.X) + float(StartOffsetX);
                    TextDesc.LineNumber = LineNr;
                    ++ LineNr;
                    TextLines.AddItem(TextDesc);
                }                
            }            
            switch(TextAlign)
            {
                case 0:
                case 1:
                case 2:
                    StartOffsetY = 0;
                    break;
                case 3:
                case 4:
                case 5:
                    StartOffsetY = int((Height - float(TotalCaptionHeight)) / float(2));
                    break;
                case 6:
                case 7:
                case 8:
                    StartOffsetY = int((Height - float(TotalCaptionHeight)) - float(1));
                    break;
                default:
                    foreach TextLines(TextDesc, I)
                    {
                        TextDesc.Position.Y += (float(StartOffsetY) + (float(TextDesc.LineNumber) * LinePaddingPx));
                        TextLines[I] = TextDesc;                        
                    }                    
            }            
}

function SetTextColor(Color C)
{
    TextColor = C;
}

function RestoreTextColor()
{
    TextColor = DefaultTextColor;
}

function SetCaption(string Text)
{
    Caption = Text;
    bScaleSet = false;
}

function RenderObject(Canvas Canvas, float DeltaTime)
{
    local float CX, CY;
    local STextLine TextDesc;

    if(bIsHidden)
    {
        return;
    }

    super.RenderObject(Canvas, DeltaTime);

    CX = Canvas.ClipX;
    CY = Canvas.ClipY;
    Canvas.Font = TextFont;

    if(!bScaleSet)
    {
        SetScale(Canvas);
        bScaleSet = true;
    }

    Canvas.DrawColor = TextColor;
    UnresolvedNativeFunction_198(Canvas.DrawColor.A, OwnerScene.Opacity * Opacity);
    SetCanvasPos(Canvas);
    Canvas.ClipX = (Canvas.CurX + Width) + CurTextPadding.X;
    Canvas.ClipY = (Canvas.CurY + Height) + CurTextPadding.Y;

    foreach TextLines(TextDesc,)
    {
        Canvas.SetPos(OwnerScene.Left + TextDesc.Position.X, OwnerScene.Top + TextDesc.Position.Y);
        Canvas.DrawText(TextDesc.Caption,, textscale * ScreenScale, textscale * ScreenScale);        
    }    

    Canvas.ClipX = CX;
    Canvas.ClipY = CY;
}

function Move(int DX, int DY)
{
    super.Move(DX, DY);
    SetCaption(Caption);
}

defaultproperties
{
    TextFont=Font'fog_fonts.grecki_font_bialy72'
    TextColor=(R=255,G=255,B=255,A=255)
    textscale=1.0
}