class GameMenuButton extends GameMenuObject;

var MenuImageDrawStyle ImageDrawStyle;
var EAlign TextAlign;
var Vector2D ImagePadding;
var Vector2D CurImagePadding;
var Texture2D Images[3];
var UVCoords ImagesUVs[3];
var float W;
var float H;
var float ImageScale;
var float Scale;
var bool bScaleSet;
var bool bGetScaleFromObject;
var bool bPlayClickAnimation;
var bool bCallOnTouchWhenClickOutside;
var LinearColor ImageColor;
var Color TextColor[3];
var LinearColor Colors[3];
var Vector2D TextSize;
var string Caption;
var Vector2D TextPos;
var float CuTextScale;
var float textscale;
var Font TextFont;
var Vector2D TextPadding;
var Vector2D CurTextPadding;
var Vector DesirePosition;
var SoundCue ButtonPressSound;
var SoundCue ButtonReleaseSound;

function InitMenuObject(MobilePlayerInput PlayerInput, MobileMenuScene Scene, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
    local int I;
    local float ImgScale;

    super.InitMenuObject(PlayerInput, Scene, ScreenWidth, ScreenHeight, bIsFirstInitialization);

    if(bIsFirstInitialization)
    {
        I = 0;
        J0x50:
        if(I < 2)
        {
            if(!ImagesUVs[I].bCustomCoords && Images[I] != none)
            {
                ImagesUVs[I].U = 0.0;
                ImagesUVs[I].V = 0.0;
                ImagesUVs[I].UL = float(Images[I].SizeX);
                ImagesUVs[I].VL = float(Images[I].SizeY);
            }
            ++ I;
            goto J0x50;
        }

        switch(ImageDrawStyle)
        {
            case 0:
                ImgScale = ((ImagesUVs[0].VL > float(0)) ? Height / ImagesUVs[0].VL : 1.0);
                W = ImagesUVs[0].UL * ImgScale;
                H = ImagesUVs[0].VL * ImgScale;
                break;
            case 1:
                W = Width;
                H = Height;
                break;
            case 2:
                W = Width;
                H = Height;
                break;
            default:
                W = W * ImageScale;
                H = H * ImageScale;
                CurImagePadding.X = ImagePadding.X * Width;
                CurImagePadding.Y = ImagePadding.Y * Height;
                Scale = ((bGetScaleFromObject) ? Height / 1080.0 : Scene.Height / 1080.0);
                CuTextScale = textscale * Scale;
                CurTextPadding.X = TextPadding.X * Width;
                CurTextPadding.Y = TextPadding.Y * Height;
            }
}

function SetScale(Canvas Canvas)
{
    local int X, Y;

    CalculateTextPosition(Caption, TextAlign, Canvas, CurTextPadding, CuTextScale, X, Y);
    TextPos.X = float(X);
    TextPos.Y = float(Y);
    bScaleSet = true;
}

function SetOpacity(bool bFullOpacity)
{
    Opacity = ((bFullOpacity) ? 1.0 : 0.50);
}

function SetCaption(coerce string Text)
{
    Caption = Text;
    bScaleSet = false;
}

function SetHidden(bool bHidden)
{
    bIsHidden = bHidden;
    bIsActive = !bHidden;
}

function SetActive(bool bActive)
{
    bIsActive = bActive;
    if(bIsActive)
    {
        bIsHidden = false;
    }
}

function SetDisabled(bool newDisabled)
{
    bIsActive = !newDisabled;
}

function SetButtonMovePosition(Vector StartPos, Vector DesirePos)
{
    DesirePosition = DesirePos;
    Left = StartPos.X - (Width / float(2));
    Top = StartPos.Y - (Height / float(2));
    DesirePosition.X -= (Width / float(2));
    DesirePosition.Y -= (Height / float(2));
    PlayAnim();
}

function RenderObject(Canvas Canvas, float DeltaTime)
{
    local int Idx;
    local LinearColor DrawColor;

    super.RenderObject(Canvas, DeltaTime);

    if(Images[0] != none)
    {
        if(bPlayClickAnimation)
        {
            if(bIsActive)
            {
                Idx = ((bIsTouched || bIsHighlighted) ? 1 : 0);
            }
            else
            {
                Idx = 2;
            }
            DrawColor = Colors[Idx];
        }
        else
        {
            DrawColor = Colors[0];
        }
        DrawColor.A *= (Opacity * OwnerScene.Opacity);
        Canvas.SetPos((OwnerScene.Left + Left) + CurImagePadding.X, (OwnerScene.Top + Top) + CurImagePadding.Y);
        Canvas.DrawTile(Images[Idx], W, H, ImagesUVs[Idx].U, ImagesUVs[Idx].V, ImagesUVs[Idx].UL, ImagesUVs[Idx].VL, DrawColor);
    }

    if(Caption != "")
    {
        RenderCaption(Canvas);
    }
}

function RenderCaption(Canvas Canvas)
{
    local float CX, CY;
    local int Idx;

    CX = Canvas.ClipX;
    CY = Canvas.ClipY;
    Canvas.Font = TextFont;

    if(!bScaleSet)
    {
        SetScale(Canvas);
    }

    Canvas.SetPos(OwnerScene.Left + TextPos.X, OwnerScene.Top + TextPos.Y);
    Idx = ((!bIsActive) ? 2 : ((bIsTouched || bIsHighlighted) ? 1 : 0));
    Canvas.DrawColor = TextColor[Idx];
    UnresolvedNativeFunction_198(Canvas.DrawColor.A, Opacity * OwnerScene.Opacity);
    Canvas.ClipX = Canvas.CurX + Width;
    Canvas.ClipY = Canvas.CurY + Height;
    Canvas.DrawText(Caption,, CuTextScale, CuTextScale);
    Canvas.ClipX = CX;
    Canvas.ClipY = CY;
}

event bool OnTouch(Engine.Interaction.ETouchType EventType, float TouchX, float TouchY, MobileMenuObject ObjectOver, float DeltaTime)
{
    if(GameOwner == none)
    {
        return false;
    }
    switch(EventType)
    {
        case 0:
            GameOwner.OnButtonClick(Tag);
            if(ButtonPressSound != none)
            {
                GameOwner.PlaySound(ButtonPressSound);
            }
            break;
        case 3:
        case 4:
            GameOwner.OnButtonClickEnd(Tag);
            if(ButtonReleaseSound != none)
            {
                GameOwner.PlaySound(ButtonReleaseSound);
            }
            if(!bIsTouched && bCallOnTouchWhenClickOutside)
            {
                GameOwner.OnTouch(self, EventType, TouchX, TouchY);
            }
            return !bIsTouched;
            break;
        default:
            return false;
    }
}

function Move(int DX, int DY)
{
    super.Move(DX, DY);
    SetCaption(Caption);
}

defaultproperties
{
    ImageDrawStyle=MenuImageDrawStyle.IDS_Stretched
    TextAlign=EAlign.A_Center
    ImagesUVs[0]=(bCustomCoords=true,U=0.0,V=0.0,UL=0.0,VL=0.0)
    ImagesUVs[1]=(bCustomCoords=true,U=0.0,V=0.0,UL=0.0,VL=0.0)
    ImagesUVs[2]=(bCustomCoords=true,U=0.0,V=0.0,UL=0.0,VL=0.0)
    ImageScale=1.0
    bPlayClickAnimation=true
    ImageColor=(R=1.0,G=1.0,B=1.0,A=1.0)
    TextColor[0]=(R=255,G=255,B=255,A=255)
    TextColor[1]=(R=255,G=255,B=255,A=255)
    TextColor[2]=(R=255,G=255,B=255,A=100)
    Colors[0]=(R=1.0,G=1.0,B=1.0,A=1.0)
    Colors[1]=(R=2.0,G=2.0,B=2.0,A=1.0)
    Colors[2]=(R=0.20,G=0.20,B=0.20,A=0.30)
    textscale=2.0
    TextFont=Font'fog_fonts.grecki_font_bialy72'
    bIsActive=true
}