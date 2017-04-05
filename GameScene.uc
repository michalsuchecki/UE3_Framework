class GameScene extends MobileMenuScene;

enum ERenderLayer
{
    E_RenderLayerDefault,
    E_RenderLayer0,
    E_RenderLayer1,
    E_RenderLayer2,
    E_RenderLayer3,
    E_RenderLayer4,
    E_RenderLayer5,
    E_RenderLayer6,
    E_RenderLayer7,
    E_RenderLayer8,
    E_RenderLayer9,
    E_RenderLayer10,
    E_RenderLayerLoading,
    E_RenderLayerDialog,
    E_RenderLayerTop,
    E_MAX
};

enum ESpace
{
    S_SceneSpace,
    S_ScreenSpace,
    S_MAX
};

enum EProportions
{
    R_Normal,
    R_WidthToHeight,
    R_HeightToWidth,
    R_MAX
};

enum EAlign
{
    A_TopLeft,
    A_TopCenter,
    A_TopRight,
    A_CenterLeft,
    A_Center,
    A_CenterRight,
    A_BottomLeft,
    A_BottomCenter,
    A_BottomRight,
    A_MAX
};

enum GameScene_Localisation
{
    GAMESCENE_MENU,
    GAMESCENE_RESTART,
    GAMESCENE_RESUME,
    GAMESCENE_CONTINUE,
    GAMESCENE_GET_MORE,
    GAMESCENE_CANCEL,
    GAMESCENE_OK,
    GAMESCENE_RATE_ME,
    GAMESCENE_DONT_ASK,
    GAMESCENE_UNLOCK,
    GAMESCENE_EULA,
    GAMESCENE_TERMS_OF_SERVICE,
    GAMESCENE_PRIVACY_POLICY,
    GAMESCENE_ABOUT,
    GAMESCENE_RESTORE_PURCHASES,
    GAMESCENE_BACK,
    GAMESCENE_BUY,
    GAMESCENE_UPGRADE,
    GAMESCENE_NEXT,
    GAMESCENE_GO,
    GAMESCENE_SELECT,
    GAMESCENE_SWAP,
    GAMESCENE_RECOMMENDED,
    GAMESCENE_MAX
};

struct SAnimInfo
{
    var Vector2D Offset;
    var LinearColor Col;
    var float Scale;
    var float Time;

    structdefaultproperties
    {
        Offset=(X=0.0,Y=0.0)
        Col=(R=0.0,G=0.0,B=0.0,A=1.0)
        Scale=0.0
        Time=0.0
    }
};

struct SDeadZone
{
    var int X;
    var int Y;
    var int XL;
    var int YL;

    structdefaultproperties
    {
        X=0
        Y=0
        XL=0
        YL=0
    }
};

var const localized array<localized string> ButtonName;
var GamePlayerController basePC;
var Vector2D ScreenSize;
var GameScene.ERenderLayer RenderLayer;
var GameScene.EProportions Proportions;
var GameScene.EProportions PaddingProportions;
var GameScene.EAlign SceneAlign;
var GameScene.ESpace SceneSpace;
var array<GameScene> ChildScene;
var Vector2D Padding;
var int MaxHeight;
var int MaxWidth;
var GameScene Owner;
var GameScene TopOwner;
var bool bIsHidden;
var bool bIgnoreRenderCulling;
var bool bUnpauseOnClose;
var bool bPauseGame;
var bool bIHandleUnpause;
var bool bEnabledTouch;
var bool bShowDebug;
var bool bFadeUp;
var bool bFadeScene;
var float FadeTimeStart;
var float FadeTimeCur;
var float DesireFade;
var float FadeStep;
var string Tag;

event InitMenuScene(MobilePlayerInput PlayerInput, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
    local float W, H;
    local int I;

    SceneCaptionFont = GetSceneFont();
    InputOwner = PlayerInput;
    ScreenSize.X = float(ScreenWidth);
    ScreenSize.Y = float(ScreenHeight);

    if((Owner == none) && SceneSpace == 0)
    {
        SceneSpace = 1;
    }

    if(bIsFirstInitialization)
    {
        basePC = GetPlayerController();
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

    if(SceneSpace == 1)
    {
        switch(Proportions)
        {
            case 0:
                H = ((bRelativeHeight) ? float(ScreenHeight) * H : H);
                if(MaxHeight > 0)
                {
                    H = float(Clamp(int(H), 0, MaxHeight));
                }
                W = ((bRelativeWidth) ? float(ScreenWidth) * W : W);
                if(MaxWidth > 0)
                {
                    W = float(Clamp(int(W), 0, MaxWidth));
                }
                break;
            case 2:
                W = ((bRelativeWidth) ? float(ScreenWidth) * W : W);
                if(MaxWidth > 0)
                {
                    W = float(Clamp(int(W), 0, MaxWidth));
                }
                H = W * H;
                break;
            case 1:
                H = ((bRelativeHeight) ? float(ScreenHeight) * H : H);
                if(MaxHeight > 0)
                {
                    H = float(Clamp(int(H), 0, MaxHeight));
                }
                W = H * W;
                break;
            default:
                switch(SceneAlign)
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
                                break;
                            }
                    }
                    switch(Proportions)
                    {
                        case 0:
                            H = ((bRelativeHeight) ? Owner.Height * H : H);
                            W = ((bRelativeWidth) ? Owner.Width * W : W);
                            break;
                        case 2:
                            W = ((bRelativeWidth) ? Owner.Width * W : W);
                            H = W * H;
                            break;
                        case 1:
                            H = ((bRelativeHeight) ? Owner.Height * H : H);
                            W = H * W;
                            break;
                        default:
                            switch(SceneAlign)
                            {
                                case 0:
                                    Left = 0.0;
                                    Top = 0.0;
                                    break;
                                case 1:
                                    Left = (Owner.Width - W) / float(2);
                                    Top = 0.0;
                                    break;
                                case 2:
                                    Left = Owner.Width - W;
                                    Top = 0.0;
                                    break;
                                case 3:
                                    Left = 0.0;
                                    Top = (Owner.Height - H) / float(2);
                                    break;
                                case 4:
                                    Left = (Owner.Width - W) / float(2);
                                    Top = (Owner.Height - H) / float(2);
                                    break;
                                case 5:
                                    Left = Owner.Width - W;
                                    Top = (Owner.Height - H) / float(2);
                                    break;
                                case 6:
                                    Left = 0.0;
                                    Top = Owner.Height - H;
                                    break;
                                case 7:
                                    Left = (Owner.Width - W) / float(2);
                                    Top = Owner.Height - H;
                                    break;
                                case 8:
                                    Left = Owner.Width - W;
                                    Top = Owner.Height - H;
                                    break;
                                default:
                                    switch(PaddingProportions)
                                    {
                                        case 0:
                                            Padding.X *= Owner.Width;
                                            Padding.Y *= Owner.Height;
                                            break;
                                        case 2:
                                            Padding.X *= Owner.Width;
                                            Padding.Y *= Padding.X;
                                            break;
                                        case 1:
                                            Padding.Y *= Owner.Height;
                                            Padding.X *= Padding.Y;
                                            break;
                                        default:
                                            Padding.X += Owner.Left;
                                            Padding.Y += Owner.Top;
                                            Left += Padding.X;
                                            Top += Padding.Y;
                                            Width = W;
                                            Height = H;
                                            I = 0;
                                            J0xF00:
                                            if(I < MenuObjects.Length)
                                            {
                                                if(GameMenuObject(MenuObjects[I]) != none)
                                                {
                                                    if(!GameMenuObject(MenuObjects[I]).bPanelElement)
                                                    {
                                                        MenuObjects[I].InitMenuObject(InputOwner, self, ScreenWidth, ScreenHeight, bIsFirstInitialization);
                                                    }
                                                }
                                                else
                                                {
                                                    MenuObjects[I].InitMenuObject(InputOwner, self, ScreenWidth, ScreenHeight, bIsFirstInitialization);
                                                }
                                                ++ I;
                                                goto J0xF00;
                                            }

                                            if(basePC != none)
                                            {
                                                if(bPauseGame && !basePC.IsPaused())
                                                {
                                                    basePC.SetPause(true);
                                                    bIHandleUnpause = basePC.IsPaused();
                                                }
                                            }
                                    }                                    
}

function GamePlayerController GetPlayerController()
{
    if(InputOwner != none)
    {
        return GamePlayerController(InputOwner.Outer.WorldInfo.GetALocalPlayerController());
    }
    return none;
}

function GameScene OpenScene(class<GameScene> SceneClass, optional string Mode, optional float NewWidth, optional float NewHeight, optional float NewPaddingX, optional float NewPaddingY)
{
    local GamePlayerInput PInput;
    local GameScene NewScene;

    NewWidth = 0.0;
    NewHeight = 0.0;
    NewPaddingX = 0.0;
    NewPaddingY = 0.0;
    PInput = GamePlayerInput(InputOwner);

    if(PInput != none)
    {
        NewScene = GameScene(PInput.GameOpenMenuScene(SceneClass, Mode, NewWidth, NewHeight, NewPaddingX, NewPaddingY, self));

        if(NewScene != none)
        {
            ChildScene.AddItem(NewScene);
            NewScene.SetOwner(self);

            if(Owner == none)
            {
                NewScene.TopOwner = self;
            }
            return NewScene;
        }
    }
    return none;
}

function GameScene FindChildScene(string SceneTag)
{
    local GameScene Result;

    foreach ChildScene(Result,)
    {
        if(Caps(Result.Tag) == Caps(SceneTag))
        {            
            return Result;
        }        
    }    
    return none;
}

function Update()
{
    local GameScene OpenedScene;

    foreach ChildScene(OpenedScene,)
    {
        OpenedScene.Update();        
    }    
}

function CloseScene(GameScene Scene)
{
    local int I;
    local GameScene OpenedScene;

    if(Scene == none)
    {
        return;
    }

    foreach ChildScene(OpenedScene, I)
    {
        if(OpenedScene == Scene)
        {
            OpenedScene.Close();
            ChildScene.Remove(I, 1);
        }        
    }    
}

function CloseAllChildScene()
{
    local GameScene OpenedScene;

    foreach ChildScene(OpenedScene,)
    {
        OpenedScene.Close();        
    }    
    ChildScene.Length = 0;
}

function GameScene GetParentByClass(Class ParentName)
{
    if(Owner != none)
    {
        return ((Owner.Class == ParentName) ? Owner : Owner.GetParentByClass(ParentName));
    }
    else
    {
        return ((TopOwner.Class == ParentName) ? TopOwner : none);
    }
}

event OnChildSceneClose(string SceneTag)
{
}

function SetPosition(int X, int Y)
{
    Left = float(X);
    Top = float(Y);
}

function HideScene(bool bHide, optional bool bHideChild)
{
    local GameScene Scene;
    local int Idx;

    bHideChild = true;
    bIsHidden = bHide;
    Idx = 0;
    J0x25:
    if(Idx < MenuObjects.Length)
    {
        if(GameMenuButton(MenuObjects[Idx]) != none)
        {
            GameMenuButton(MenuObjects[Idx]).SetHidden(bHide);
        }
        ++ Idx;
        goto J0x25;
    }
    if(bHideChild)
    {
        foreach ChildScene(Scene,)
        {
            Scene.HideScene(bHide);            
        }        
    }
}

function RenderScene(Canvas Canvas, float RenderDelta)
{
    if((bIsHidden || (basePC != none) && !basePC.myHUD.bShowHUD) || !bIgnoreRenderCulling && ((((Top + Height) < float(0)) || (Left + Width) < float(0)) || Left > ScreenSize.X) || Top > ScreenSize.Y)
    {
        return;
    }

    if(bFadeScene)
    {
        OnFadeUpdate(RenderDelta);
    }

    super.RenderScene(Canvas, RenderDelta);

    if(bShowDebug)
    {
        Canvas.SetPos(Left, Top);
        Canvas.DrawColor = MakeColor(0, 255, 0, byte(Opacity * float(255)));
        Canvas.DrawBox(Width, Height);
    }
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
    bFadeScene = true;
    bFadeUp = Opacity < TargetFade;

    if(bFadeUp)
    {
        bIsHidden = false;
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
                bFadeScene = false;
            }
        }
        else
        {
            Opacity -= (DeltaTime * FadeStep);
            if(Opacity <= DesireFade)
            {
                Opacity = DesireFade;
                bFadeScene = false;
                if(Opacity == 0.0)
                {
                    bIsHidden = true;
                }
            }
        }
    }
}

function EnableTouch(bool bEnable)
{
    local GameScene Scene;

    if(bEnabledTouch == bEnable)
    {
        return;
    }

    bEnabledTouch = bEnable;

    foreach ChildScene(Scene,)
    {
        Scene.EnableTouch(bEnabledTouch);        
    }    
}

function OnTouch(MobileMenuObject Sender, Engine.Interaction.ETouchType Type, float TouchX, float TouchY)
{
    if(basePC != none)
    {
        basePC.OnSceneTouch(Sender, Type, TouchX, TouchY);
    }

    if((TopOwner != none) && ((Type == 0) || Type == 3) || Type == 4)
    {
        TopOwner.TouchOther(self, Type, TouchX, TouchY);
    }
}

final function TouchOther(GameScene Scene, Engine.Interaction.ETouchType Type, float X, float Y)
{
    local int I;

    if(Scene != self)
    {
        TouchOtherScene(Type, X, Y);
    }

    I = 0;
    J0x3F:
    if(I < ChildScene.Length)
    {
        ChildScene[I].super(GameScene).TouchOther(Scene, Type, X, Y);
        ++ I;
        goto J0x3F;
    }
}

function TouchOtherScene(Engine.Interaction.ETouchType Type, float X, float Y)
{
}

function TouchOutsideScene(Engine.Interaction.ETouchType Type, float X, float Y)
{
    local int I;

    I = 0;
    J0x0B:
    if(I < ChildScene.Length)
    {
        ChildScene[I].TouchOutsideScene(Type, X, Y);
        ++ I;
        goto J0x0B;
    }
}

function TouchSubScene(string SceneTag)
{
}

function SetOwner(GameScene Own)
{
    Owner = Own;
}

function Close()
{
    if(bIHandleUnpause && bUnpauseOnClose)
    {
        basePC.SetPause(false);
    }

    CloseAllChildScene();

    if(Owner != none)
    {
        Owner.OnChildSceneClose(MenuName);
    }

    if(InputOwner != none)
    {
        InputOwner.CloseMenuScene(self);
    }
}

function PlaySound(SoundCue Sound)
{
    if(Sound != none)
    {
        basePC.super(GameScene).PlaySound(Sound, true);
    }
}

function OnAnimStart(string ObjectTag)
{
}

function OnAnimTick(string ObjectTag)
{
}

function OnAnimEnd(string ObjectTag)
{
}

function OnButtonClick(string ObjectTag)
{
}

function OnButtonClickEnd(string ObjectTag)
{
}

function OnBarClick(string ObjectTag, float Val)
{
}

function OnBarRelease(string ObjectTag, float Val)
{
}

function OnBarMaxValue(string ObjectTag, float Val)
{
}

function OnBarMinValue(string ObjectTag, float Val)
{
}

function OnBarValueChanged(string ObjectTag, float Val)
{
}

function RespawnScene(name StateName)
{
    local GameScene Scene;

    foreach ChildScene(Scene,)
    {
        Scene.RespawnScene(StateName);        
    }    
}

static function string printf(string Caption, array<string> Values)
{
    local int I, val_idx, pos;
    local array<string> Split;
    local string Result, R;

    Split = SplitString(Caption, ">", true);

    foreach Split(R, I)
    {
        pos = InStr(R, "<");
        val_idx = int(Mid(R, pos + 1, (Len(R) - pos) - 1));
        R = Mid(R, 0, pos);

        if((val_idx < Values.Length) && pos > -1)
        {
            R $= Values[val_idx];
        }

        Result $= R;        
    }    
    return Result;
}

static function string FormatFloat(float Value, int Count)
{
    local array<string> Split;

    Split = SplitString(string(Value), ".", true);
    return ((Count > 0) ? (Split[0] $ ".") $ Mid(Split[1], 0, Count) : Split[0]);
}

function string FormatNumber(coerce optional string Number, optional int Space, optional string Symbol)
{
    local int NumberLength, Start, Idx;
    local string Result;

    Number = "0";
    Space = 3;
    Symbol = ",";
    if(Space == 0)
    {
        return Number;
    }
    NumberLength = Len(Number);
    Start = Ceil(NumberLength, Space);
    Result = class'Object'.static.Left(Number, Start);

    Idx = Start;
    J0xA6:
    if(Idx < NumberLength)
    {
        if(Idx != 0)
        {
            Result $= (Symbol $ Mid(Number, Idx, Space));
        }
        else
        {
            Result $= Mid(Number, Idx, Space);
        }
        Idx += Space;
        goto J0xA6;
    }
    return Result;
}

function bool IsInButton(MobileMenuObject Sender, float TouchX, float TouchY)
{
    local GameMenuButton B;

    B = GameMenuButton(Sender);
    if(B == none)
    {
        return false;
    }
    return B.isInside(TouchX, B.OwnerScene.Left + Sender.Left, Sender.Width) && B.isInside(TouchY, B.OwnerScene.Top + Sender.Top, Sender.Height);
}

defaultproperties
{
    SceneAlign=EAlign.A_Center
    SceneSpace=ESpace.S_ScreenSpace
    bUnpauseOnClose=true
    bRelativeLeft=true
    bRelativeTop=true
    bRelativeWidth=true
    bRelativeHeight=true
    Width=1.0
    Height=1.0
}