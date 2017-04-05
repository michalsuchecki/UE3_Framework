class GameMenuRichLabel extends GameMenuObject;

struct STextFragment
{
    var string Caption;
    var int ColorNr;
    var Vector2D Position;

    structdefaultproperties
    {
        Caption=""
        ColorNr=0
        Position=(X=0.0,Y=0.0)
    }
};

var array<Color> Colors;
var Font TextFont;
var float textscale;
var EAlign TextAlign;
var float ScreenScale;
var bool bScaleSet;
var Vector2D TextPadding;
var Vector2D CurTextPadding;
var float LinePadding;
var float CurLinePadding;
var array<STextFragment> TextLines;
var string Caption;

function InitMenuObject(MobilePlayerInput PlayerInput, MobileMenuScene Scene, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
    super.InitMenuObject(PlayerInput, Scene, ScreenWidth, ScreenHeight, bIsFirstInitialization);

    if(bPanelElement)
    {
        ScreenScale = Panel.Height / 1080.0;
    }
    else
    {
        ScreenScale = Scene.Height / 1080.0;
    }

    CurTextPadding.X = TextPadding.X * Width;
    CurTextPadding.Y = TextPadding.Y * Height;
    CurLinePadding = LinePadding * Height;
    SetCaption(Caption);
}

function SetScale(Canvas C)
{
    local int OffsetX, OffsetY, I, J, NewColor, CurColor, LineNr;

    local float TX, TY;
    local STextFragment TextDesc;
    local array<string> TLines, TString;
    local string ParseText;
    local bool bNewLine;
    local int LineIDXStart, LineIDXEnd, K, StartOffsetX, StartOffsetY;

    TextLines.Length = 0;
    ParseStringIntoArray(Caption, TLines, "\\n", true);

    foreach TLines(ParseText, I)
    {
        TLines[I] = Repl(ParseText, "\\n", "", false);        
    }    

    CurColor = 0;
    OffsetX = 0;
    LineNr = 0;
    LineIDXStart = 0;
    LineIDXEnd = 0;

    foreach TLines(ParseText, I)
    {
        ParseStringIntoArray(ParseText, TString, "}", true);
        LineIDXStart = TextLines.Length;

        foreach TString(ParseText, J)
        {
            if(InStr(ParseText, "{") != -1)
            {
                NewColor = int(Mid(Right(ParseText, 2), 1, 1));
                ParseText = Mid(ParseText, 0, Len(ParseText) - 2);
            }

            if(Len(ParseText) > 0)
            {
                bNewLine = (TString.Length - 1) == J;
                C.TextSize(ParseText, TX, TY, textscale * ScreenScale, textscale * ScreenScale);
                TextDesc.Caption = ParseText;
                TextDesc.Position.Y = (Top + CurTextPadding.Y) + (float(LineNr) * TY);
                TextDesc.Position.X = (Left + CurTextPadding.X) + float(OffsetX);
                OffsetX += int(TX);
                TextDesc.ColorNr = CurColor;
                TextLines.AddItem(TextDesc);

                if(bNewLine)
                {
                    OffsetY += int(TY);
                    LineIDXEnd = TextLines.Length;
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
                            StartOffsetX = int((Width - float(OffsetX)) / float(2));
                            break;
                        case 2:
                        case 5:
                        case 8:
                            StartOffsetX = int((Width - float(OffsetX)) - float(1));
                            break;
                        default:
                            K = LineIDXStart;
			J0x449:
                            if(K < LineIDXEnd)
                            {
                                TextLines[K].Position.X += float(StartOffsetX);
                                ++ K;
                                goto J0x449;
                            }
                            OffsetX = 0;
                            ++ LineNr;
                        }
                    }
                    CurColor = NewColor;                    
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
                    StartOffsetY = int((Height - float(OffsetY)) / float(2));
                    break;
                case 6:
                case 7:
                case 8:
                    StartOffsetY = int((Height - float(OffsetY)) - float(1));
                    break;
                default:
                    foreach TextLines(TextDesc, I)
                    {
                        TextDesc.Position.Y += (float(StartOffsetY) + (float(I) * CurLinePadding));
                        TextLines[I] = TextDesc;                        
                    }                    
            }            
}

function SetCaption(string Text)
{
    Caption = Text;
    bScaleSet = false;
}

function RenderObject(Canvas Canvas, float DeltaTime)
{
    local float CX, CY;
    local STextFragment TextDesc;

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

    SetCanvasPos(Canvas);
    Canvas.ClipX = Canvas.CurX + Width;
    Canvas.ClipY = Canvas.CurY + Height;

    foreach TextLines(TextDesc,)
    {
        Canvas.DrawColor = Colors[Clamp(TextDesc.ColorNr, 0, Colors.Length - 1)];
        UnresolvedNativeFunction_198(Canvas.DrawColor.A, OwnerScene.Opacity * Opacity);
        Canvas.SetPos(OwnerScene.Left + TextDesc.Position.X, OwnerScene.Top + TextDesc.Position.Y);
        Canvas.DrawText(TextDesc.Caption,, textscale * ScreenScale, textscale * ScreenScale);        
    }    

    if(bShowDebug)
    {
        ShowDebug(Canvas);
    }

    Canvas.ClipX = CX;
    Canvas.ClipY = CY;
}

final function ShowDebug(Canvas Canvas)
{
    local float PX, Py;

    GetRealPosition(PX, Py);
    Canvas.SetDrawColor(200, 200, 200, 128);
    Canvas.SetPos(PX, Py);
    Canvas.DrawRect(Canvas.ClipX, Canvas.ClipY);
}

defaultproperties
{
    TextFont=Font'fog_fonts.grecki_font_bialy72'
    textscale=0.40
}