class GamePlayerController extends GamePlayerController
    config(GameGame)
    hidecategories(Navigation);

var GameGameInfo GameInfo;
var GamePlayerInput MPI;
var bool bFacebookClickBlocked;
var bool bMovingBackToPrevState;
var bool bUseGameCenter;
var name DestinationState;
var GameGameCenter GameCenter;
var delegate<OnKeyboardClose> __OnKeyboardClose__Delegate;

simulated function PostBeginPlay()
{
    super(PlayerController).PostBeginPlay();
    GameInfo = GameGameInfo(WorldInfo.Game);

    if(bUseGameCenter)
    {
        GameCenter = new (self) class'GameGameCenter';
        GameCenter.Initialize();
    }
}

function Destroyed()
{
    if(GameCenter != none)
    {
        GameCenter.Destroyed();
        GameCenter = none;
    }

    super(PlayerController).Destroyed();
}

exec function AchievementsUnlock(int AchievementId)
{
    if(GameCenter != none)
    {
        GameCenter.UnlockAchievement(AchievementId);
    }
}

exec function GameCenterShowUI()
{
    if(GameCenter != none)
    {
        GameCenter.ShowUI();
    }
}

function RespawnHUD()
{
}

exec function BackToState(name StateName)
{
    DestinationState = StateName;
    bMovingBackToPrevState = true;
    PopState();
}

event InitInputSystem()
{
    super(PlayerController).InitInputSystem();
    MPI = GamePlayerInput(PlayerInput);
    MPI.__OnInputTouch__Delegate = HandleTouch;
}

function Vector2D GetViewportSize()
{
    local Vector2D ViewportSize;

    LocalPlayer(Player).ViewportClient.super(GamePlayerController).GetViewportSize(ViewportSize);
    return ViewportSize;
}

function HandleTouch(int Handle, Engine.Interaction.ETouchType Type, Vector2D TouchLocation, float DeviceTimestamp, int TouchpadIndex)
{
}

function OnSceneTouch(MobileMenuObject Sender, Engine.Interaction.ETouchType Type, float TouchX, float TouchY)
{
}

function DeprojectForTrace(Vector2D ScreenLocation, out Vector TraceStart, out Vector TraceEnd)
{
    local Vector2D VP, RelScreenLocation;
    local Vector WorldOrigin, WorldDirection;

    VP = GetViewportSize();
    RelScreenLocation.X = ScreenLocation.X / VP.X;
    RelScreenLocation.Y = ScreenLocation.Y / VP.Y;

    if(LocalPlayer(Player) != none)
    {
        LocalPlayer(Player).FastDeProject(RelScreenLocation, WorldOrigin, WorldDirection);
        TraceStart = WorldOrigin;
        TraceEnd = WorldOrigin + (WorldDirection * float(50000));
    }
}

function Actor TraceActor(Vector2D TouchLocation)
{
    local Vector Start, End, HitNormal, HitLocation;
    local Actor A;

    DeprojectForTrace(TouchLocation, Start, End);
    A = Trace(HitLocation, HitNormal, End, Start, true);
    return A;
}

function OpenDeviceKeyboard(string WndTitle, string DefaultText, optional string OnOK, optional string OnCANCEL, optional string MaxLength)
{
    OnOK = "OnKeyboardOK";
    OnCANCEL = "OnKeyboardCANCEL";
    MaxLength = "32";
    ConsoleCommand(((((((((("mobile getuserinput \\"" $ WndTitle) $ "\\" \\"") $ DefaultText) $ "\\" \\"") $ OnOK) $ "\\"\\"") $ OnCANCEL) $ "\\"\\"") $ MaxLength) $ "\\"");
}

exec function OnKeyboardOK(string Caption)
{
    if(__OnKeyboardClose__Delegate != none)
    {
        OnKeyboardClose(true, Caption);
        __OnKeyboardClose__Delegate = None;
    }

}

exec function OnKeyboardCANCEL()
{
    if(__OnKeyboardClose__Delegate != none)
    {
        OnKeyboardClose(false, "");
        __OnKeyboardClose__Delegate = None;
    }
}

exec function MyKeyboard(string Caption)
{
    if(__OnKeyboardClose__Delegate != none)
    {
        OnKeyboardClose(true, Caption);
        __OnKeyboardClose__Delegate = None;
    }
}

delegate OnKeyboardClose(bool bSuccess, string Caption)
{
}

function LaunchFacebook()
{
    if(bFacebookClickBlocked)
    {
        return;
    }
    bFacebookClickBlocked = true;
    SetTimer(3.0, false, 'OnFacebookClick');
    ConsoleCommand("mobile facebook 182743375185296");
}

function OnFacebookClick()
{
    bFacebookClickBlocked = false;
}

exec function ClearLocalNotifications()
{
    local AppNotificationsBase AppNotification;

    AppNotification = class'PlatformInterfaceBase'.static.GetAppNotificationsInterface();

    if(AppNotification == none)
    {
        return;
    }

    AppNotification.CancelAllScheduledLocalNotifications();
}

exec function SetupLocalNotification(string Text, int SecondsFromNow, int Badges)
{
    local AppNotificationsBase AppNotification;
    local NotificationInfo NotificationInfo;

    AppNotification = class'PlatformInterfaceBase'.static.GetAppNotificationsInterface();

    if(AppNotification == none)
    {
        return;
    }

    NotificationInfo.BadgeNumber = Badges;
    NotificationInfo.MessageBody = Text;
    AppNotification.ScheduleLocalNotification(NotificationInfo, SecondsFromNow);
}

state BaseState
{
    ignores PoppedState, PausedState;

    event BeginState(name PreviousStateName)
    {
        RespawnHUD();
    }

    event PushedState()
    {
        RespawnHUD();
    }

    event ContinuedState()
    {
        if(bMovingBackToPrevState)
        {
            if(GetStateName() != DestinationState)
            {
                PopState();
            }
            else
            {
                bMovingBackToPrevState = false;
            }
        }
        if(!bMovingBackToPrevState)
        {
            RespawnHUD();
        }
    }
    stop;    
}

defaultproperties
{
    bUseGameCenter=true
    CameraClass=class'GameCamera'
    InputClass=class'GamePlayerInput'

    begin object name=CollisionCylinder class=CylinderComponent
        ReplacementPrimitive=none
    object end

    CylinderComponent=CollisionCylinder
    Components(0)=CollisionCylinder
    CollisionComponent=CollisionCylinder
}