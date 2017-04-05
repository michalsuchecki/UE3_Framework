class GameMenuObject extends MobileMenuObject;

var EProportions Proportions;
var EProportions PaddingProportions;
var EAlign Align;
var ESpace ObjectSpace;
var Vector2D Padding;
var GameScene GameOwner;
var bool bPanelElement;
var bool bPlayAnim;
var bool bReversPlay;
var bool bLoopAnim;
var bool bFadeUp;
var bool bFadeObject;
var bool bShowDebug;
var bool bMovable;
var int AnimIDX;
var float AnimCurTime;
var array<SAnimInfo> AnimInfo;
var float AnimCurScale;
var LinearColor AnimCurColor;
var Vector2D AnimCurOffset;
var float TextSizeX;
var float TextSizeY;
var float FadeTimeStart;
var float FadeTimeCur;
var float DesireFade;
var float FadeStep;

function InitMenuObject(MobilePlayerInput PlayerInput, MobileMenuScene Scene, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
    local float W, H;

    InputOwner = PlayerInput;
    OwnerScene = Scene;

    if(!bHasBeenInitialized || !bIsFirstInitialization)
    {

        if(bIsFirstInitialization)
        {
            W = Width;
            H = Height;
            InitialTop = Padding.Y;
            InitialLeft = Padding.X;
            InitialWidth = W;
            InitialHeight = H;
        }
        else
        {
            Padding.Y = InitialTop;
            Padding.X = InitialLeft;
            W = InitialWidth;
            H = InitialHeight;
        }

        if(ObjectSpace == 0)
        {
            switch(Proportions)
            {
                case 0:
                    H = ((bRelativeHeight) ? Scene.Height * H : H);
                    W = ((bRelativeWidth) ? Scene.Width * W : W);
                    break;
                case 2:
                    W = ((bRelativeWidth) ? Scene.Width * W : W);
                    H = W * H;
                    break;
                case 1:
                    H = ((bRelativeHeight) ? Scene.Height * H : H);
                    W = H * W;
                    break;
                default:
                    break;
                }
        }
        switch(Proportions)
        {
            case 0:
                H = ((bRelativeHeight) ? float(ScreenHeight) * H : H);
                W = ((bRelativeWidth) ? float(ScreenWidth) * W : W);
                break;
            case 2:
                W = ((bRelativeWidth) ? float(ScreenWidth) * W : W);
                H = W * H;
                break;
            case 1:
                H = ((bRelativeHeight) ? float(ScreenHeight) * H : H);
                W = H * W;
                break;
            default:
                if(ObjectSpace == 0)
                {
                    switch(Align)
                    {
                        case 0:
                            Left = 0.0;
                            Top = 0.0;
                            break;
                        case 1:
                            Left = (Scene.Width - W) / float(2);
                            Top = 0.0;
                            break;
                        case 2:
                            Left = Scene.Width - W;
                            Top = 0.0;
                            break;
                        case 3:
                            Left = 0.0;
                            Top = (Scene.Height - H) / float(2);
                            break;
                        case 4:
                            Left = (Scene.Width - W) / float(2);
                            Top = (Scene.Height - H) / float(2);
                            break;
                        case 5:
                            Left = Scene.Width - W;
                            Top = (Scene.Height - H) / float(2);
                            break;
                        case 6:
                            Left = 0.0;
                            Top = Scene.Height - H;
                            break;
                        case 7:
                            Left = (Scene.Width - W) / float(2);
                            Top = Scene.Height - H;
                            break;
                        case 8:
                            Left = Scene.Width - W;
                            Top = Scene.Height - H;
                            break;
                        default:
                            break;
                        }
                }
                switch(Align)
                {
                    case 0:
                        Left = 0.0;
                        Top = 0.0;
                        break;
                    case 1:
                        Left = (float(ScreenWidth) - W) / float(2);
                        Top = 0.0;
                        break;
                    case 2:
                        Left = float(ScreenWidth) - W;
                        Top = 0.0;
                        break;
                    case 3:
                        Left = 0.0;
                        Top = (float(ScreenHeight) - H) / float(2);
                        break;
                    case 4:
                        Left = (float(ScreenWidth) - W) / float(2);
                        Top = (float(ScreenHeight) - H) / float(2);
                        break;
                    case 5:
                        Left = float(ScreenWidth) - W;
                        Top = (float(ScreenHeight) - H) / float(2);
                        break;
                    case 6:
                        Left = 0.0;
                        Top = float(ScreenHeight) - H;
                        break;
                    case 7:
                        Left = (float(ScreenWidth) - W) / float(2);
                        Top = float(ScreenHeight) - H;
                        break;
                    case 8:
                        Left = float(ScreenWidth) - W;
                        Top = float(ScreenHeight) - H;
                        break;
                    default:
                        if(ObjectSpace == 0)
                        {
                            switch(PaddingProportions)
                            {
                                case 0:
                                    Padding.X *= Scene.Width;
                                    Padding.Y *= Scene.Height;
                                    break;
                                case 2:
                                    Padding.X *= Scene.Width;
                                    Padding.Y *= Padding.X;
                                    break;
                                case 1:
                                    Padding.Y *= Scene.Height;
                                    Padding.X *= Padding.Y;
                                    break;
                                default:
                                    break;
                                }
                        }
                        switch(PaddingProportions)
                        {
                            case 0:
                                Padding.X *= float(ScreenWidth);
                                Padding.Y *= float(ScreenHeight);
                                break;
                            case 2:
                                Padding.X *= float(ScreenWidth);
                                Padding.Y *= Padding.X;
                                break;
                            case 1:
                                Padding.Y *= float(ScreenHeight);
                                Padding.X *= Padding.Y;
                                break;
                            default:
                                Left -= Scene.Left;
                                Top -= Scene.Top;
                                Left += Padding.X;
                                Top += Padding.Y;
                                Width = W;
                                Height = H;
                            }
                            bHasBeenInitialized = true;
                            GameOwner = GameScene(Scene);
}

function CalculateTextPosition(string Text, GameScene.EAlign TextAlign, Canvas C, Vector2D TPadding, float Scale, out int PosX, out int PosY)
{
    local int MyTop, MyLeft;

    MyTop = int(Top);
    MyLeft = int(Left);
    C.TextSize(Text, TextSizeX, TextSizeY, Scale, Scale);

    switch(TextAlign)
    {
        case 0:
            PosY = MyTop;
            PosX = MyLeft;
            break;
        case 1:
            PosY = MyTop;
            PosX = int(float(MyLeft) + ((Width - TextSizeX) / float(2)));
            break;
        case 2:
            PosY = MyTop;
            PosX = int(((float(MyLeft) + Width) - TextSizeX) - float(1));
            break;
        case 3:
            PosY = int(float(MyTop) + ((Height - TextSizeY) / float(2)));
            PosX = MyLeft;
            break;
        case 4:
            PosY = int(float(MyTop) + ((Height - TextSizeY) / float(2)));
            PosX = int(float(MyLeft) + ((Width - TextSizeX) / float(2)));
            break;
        case 5:
            PosY = int(float(MyTop) + ((Height - TextSizeY) / float(2)));
            PosX = int(((float(MyLeft) + Width) - TextSizeX) - float(1));
            break;
        case 6:
            PosY = int((float(MyTop) + Height) - TextSizeY);
            PosX = MyLeft;
            break;
        case 7:
            PosY = int((float(MyTop) + Height) - TextSizeY);
            PosX = int(float(MyLeft) + ((Width - TextSizeX) / float(2)));
            break;
        case 8:
            PosY = int((float(MyTop) + Height) - TextSizeY);
            PosX = int(((float(MyLeft) + Width) - TextSizeX) - float(1));
            break;
        default:
            PosY += int(TPadding.Y);
            PosX += int(TPadding.X);
    }    
}

event bool OnTouch(Engine.Interaction.ETouchType EventType, float TouchX, float TouchY, MobileMenuObject ObjectOver, float DeltaTime)
{
    return false;
}

function RenderObject(Canvas Canvas, float DeltaTime)
{
    if(bFadeObject)
    {
        OnFadeUpdate(DeltaTime);
    }

    if((bPlayAnim && GameOwner != none) && !GameOwner.basePC.IsPaused())
    {
        AnimTick(Canvas, DeltaTime);
        OnAnimTick(Canvas, DeltaTime);
    }
    super.RenderObject(Canvas, DeltaTime);
    if(bShowDebug)
    {
        OnDebugDraw(Canvas, DeltaTime);
    }
}

function OnDebugDraw(Canvas Canvas, float DeltaTime)
{
    Canvas.SetPos(OwnerScene.Left + Left, OwnerScene.Top + Top);
    Canvas.DrawColor = MakeColor(255, 0, 0, 255);
    Canvas.DrawBox(Width, Height);
}

function PlayAnim(optional bool bPlayReverse)
{
    bPlayAnim = true;
    bReversPlay = bPlayReverse;

    if(!bPlayReverse)
    {
        AnimCurTime = 0.0;
        AnimIDX = 0;
    }
    else
    {
        AnimIDX = AnimInfo.Length - 1;
        AnimCurTime = AnimInfo[AnimIDX].Time;
    }
    if(GameOwner != none)
    {
        GameOwner.OnAnimStart(Tag);
    }

}

function StopAnim()
{
    bPlayAnim = false;

    if(GameOwner != none)
    {
        GameOwner.OnAnimEnd(Tag);
    }
}

function EndAnim()
{
    bPlayAnim = false;

    if(GameOwner != none)
    {
        GameOwner.OnAnimEnd(Tag);
    }
}

static final function Color LinearToColor(LinearColor LColor)
{
    local Color C;

    C.R = byte(float(255) * LColor.R);
    C.G = byte(float(255) * LColor.G);
    C.B = byte(float(255) * LColor.B);
    C.A = byte(float(255) * LColor.A);
    return C;
}

static final function LinearColor LerpLinearColor(LinearColor A, LinearColor B, float Alpha)
{
    local LinearColor Result;

    Result.R = Lerp(A.R, B.R, Alpha);
    Result.G = Lerp(A.G, B.G, Alpha);
    Result.B = Lerp(A.B, B.B, Alpha);
    Result.A = Lerp(A.A, B.A, Alpha);
    return Result;
}

static final function Vector2D LerpVector2D(Vector2D A, Vector2D B, float Alpha)
{
    local Vector2D Result;

    Result.X = Lerp(A.X, B.X, Alpha);
    Result.Y = Lerp(A.Y, B.Y, Alpha);
    return Result;
}

function AnimTick(Canvas Canvas, float DeltaTime)
{
    local float Alpha;

    if(!bReversPlay)
    {
        AnimCurTime += DeltaTime;
        if(AnimIDX < (AnimInfo.Length - 1))
        {
            if(AnimCurTime > AnimInfo[AnimIDX + 1].Time)
            {
                ++ AnimIDX;
            }
        }
        if(AnimIDX == (AnimInfo.Length - 1))
        {
            if(bLoopAnim)
            {
                AnimIDX = 0;
            }
            else
            {
                EndAnim();
            }
            AnimCurTime = AnimInfo[AnimIDX].Time;
            AnimCurScale = AnimInfo[AnimIDX].Scale;
            AnimCurColor = AnimInfo[AnimIDX].Col;
            AnimCurOffset = AnimInfo[AnimIDX].Offset;
        }
        else
        {
            Alpha = class'Object'.static.FPctByRange(AnimCurTime, AnimInfo[AnimIDX].Time, AnimInfo[AnimIDX + 1].Time);
            AnimCurScale = Lerp(AnimInfo[AnimIDX].Scale, AnimInfo[AnimIDX + 1].Scale, Alpha);
            AnimCurColor = LerpLinearColor(AnimInfo[AnimIDX].Col, AnimInfo[AnimIDX + 1].Col, Alpha);
            AnimCurOffset = LerpVector2D(AnimInfo[AnimIDX].Offset, AnimInfo[AnimIDX + 1].Offset, Alpha);
        }
    }
    else
    {
        AnimCurTime -= DeltaTime;
        if(AnimIDX > 0)
        {
            if(AnimCurTime <= AnimInfo[AnimIDX - 1].Time)
            {
                -- AnimIDX;
            }
        }

        if(AnimIDX == 0)
        {
            if(bLoopAnim)
            {
                AnimIDX = AnimInfo.Length - 1;
            }
            else
            {
                EndAnim();
            }
            AnimCurTime = AnimInfo[AnimIDX].Time;
            AnimCurScale = AnimInfo[AnimIDX].Scale;
            AnimCurColor = AnimInfo[AnimIDX].Col;
            AnimCurOffset = AnimInfo[AnimIDX].Offset;
        }
        else
        {
            Alpha = class'Object'.static.FPctByRange(AnimCurTime, AnimInfo[AnimIDX - 1].Time, AnimInfo[AnimIDX].Time);
            AnimCurScale = Lerp(AnimInfo[AnimIDX - 1].Scale, AnimInfo[AnimIDX].Scale, Alpha);
            AnimCurColor = LerpLinearColor(AnimInfo[AnimIDX - 1].Col, AnimInfo[AnimIDX].Col, Alpha);
            AnimCurOffset = LerpVector2D(AnimInfo[AnimIDX - 1].Offset, AnimInfo[AnimIDX].Offset, Alpha);
        }
    }

    if((GameOwner != none) && bPlayAnim)
    {
        GameOwner.OnAnimTick(Tag);
    }
}

function OnAnimTick(Canvas Canvas, float DeltaTime)
{
}

function Fade(float TargetFade, float FadeTime, optional float TimeToStart)
{
    local float FadeDiff;

    TimeToStart = 0.0;
    DesireFade = FClamp(TargetFade, 0.0, 1.0);
    FadeDiff = Abs(Opacity - DesireFade);

    if((FadeDiff == float(0)) || FadeTime == float(0))
    {
        return;
    }

    FadeStep = FadeDiff / FadeTime;
    bFadeObject = true;
    bFadeUp = Opacity < TargetFade;

    if(bFadeUp)
    {
        bIsHidden = false;
    }
    else
    {
        bIsActive = false;
    }

    FadeTimeStart = ((TimeToStart != 0.0) ? TimeToStart : 0.0);
    FadeTimeCur = 0.0;
}

function OnFadeUpdate(float DeltaTime)
{
    if(FadeTimeCur < FadeTimeStart)
    {
        FadeTimeCur += DeltaTime;
    }
    else
    {
        if(bFadeUp)
        {
            Opacity += (DeltaTime * FadeStep);
            if(Opacity >= DesireFade)
            {
                Opacity = DesireFade;
                bIsActive = true;
                bFadeObject = false;
            }
        }
        else
        {
            Opacity -= (DeltaTime * FadeStep);

            if(Opacity <= DesireFade)
            {
                Opacity = DesireFade;
                bFadeObject = false;

                if(Opacity == 0.0)
                {
                    bIsHidden = true;
                }
            }
        }
    }
}

function Move(int DX, int DY)
{
    Top += float(DY);
    Left += float(DX);
}

static function bool isBetween(float X, float X1, float X2)
{
    if(X2 < X1)
    {
        X1 += X2;
        X2 = X1 - X2;
        X1 -= X2;
    }
    return (X1 <= X) && X <= X2;
}

static function bool isInside(float X, float lower, float Len)
{
    return (lower <= X) && X <= (lower + Len);   
}

defaultproperties
{
    AnimInfo(0)=(Offset=(X=0.0,Y=0.0),Col=(R=0.0,G=0.0,B=0.0,A=1.0),Scale=1.0,Time=0.0)
    AnimCurColor=(R=0.0,G=0.0,B=0.0,A=1.0)
    bRelativeLeft=true
    bRelativeTop=true
    bRelativeWidth=true
    bRelativeHeight=true
}