class GameGameCenter extends Object;

var array<AchievementDetails> DownloadedAchievements;
var array<int> PendingAchievements;
var bool ProcessingAchievements;
var GamePlayerController PC;
var OnlineSubsystem OS;

function Initialize()
{
    PC = GamePlayerController(Outer);
    OS = class'GameEngine'.static.GetOnlineSubsystem();
}

event Destroyed()
{
    local int PlayerControllerId;

    if((OS == none) || EqualEqual_InterfaceInterface(OS.PlayerInterface, (none)))
    {
        return;
    }
    // End:0x102
    if(true)
    {
        PlayerControllerId = GetALocalPlayerControllerId();
        OS.PlayerInterface.ClearReadAchievementsCompleteDelegate(byte(PlayerControllerId), InternalOnReadAchievementsComplete);
        OS.PlayerInterface.ClearUnlockAchievementCompleteDelegate(byte(PlayerControllerId), InternalOnUnlockAchievementComplete);
    }
    //return;    
}

function ShowUI()
{
    // End:0x48
    if((OS == none) || EqualEqual_InterfaceInterface(OS.PlayerInterfaceEx, (none)))
    {
        return;
    }
    OS.PlayerInterfaceEx.ShowAchievementsUI(byte(GetALocalPlayerControllerId()));
    //return;    
}

function UnlockAchievement(int AchievementId)
{
    local int PlayerControllerId;

    // End:0x22
    if(PendingAchievements.Find(AchievementId) != -1)
    {
        return;
    }
    PendingAchievements.AddItem(AchievementId);
    // End:0x141
    if(!ProcessingAchievements)
    {
        // End:0x141
        if((OS != none) && NotEqual_InterfaceInterface(OS.PlayerInterface, (none)))
        {
            PlayerControllerId = GetALocalPlayerControllerId();
            OS.PlayerInterface.AddReadAchievementsCompleteDelegate(byte(PlayerControllerId), InternalOnReadAchievementsComplete);
            OS.PlayerInterface.ReadAchievements(byte(PlayerControllerId));
            ProcessingAchievements = true;
        }
    }
    //return;    
}

function InternalOnReadAchievementsComplete(int TitleId)
{
    local int AchievementIndex, PlayerControllerId;

    // End:0x48
    if((OS == none) || EqualEqual_InterfaceInterface(OS.PlayerInterface, (none)))
    {
        return;
    }
    PlayerControllerId = GetALocalPlayerControllerId();
    DownloadedAchievements.Remove(0, DownloadedAchievements.Length);
    OS.PlayerInterface.GetAchievements(byte(PlayerControllerId), DownloadedAchievements, TitleId);

    if((DownloadedAchievements.Length > 0) && PendingAchievements.Length > 0)
    {
        J0xE6:
        if(PendingAchievements.Length > 0)
        {
            AchievementIndex = DownloadedAchievements.Find('Id', PendingAchievements[0]);
            if((AchievementIndex != -1) && !DownloadedAchievements[AchievementIndex].bWasAchievedOnline)
            {
                OS.PlayerInterface.AddUnlockAchievementCompleteDelegate(byte(PlayerControllerId), InternalOnUnlockAchievementComplete);
                OS.PlayerInterface.UnlockAchievement(byte(PlayerControllerId), PendingAchievements[0]);
                goto J0x215;
            }
            else
            {
                PendingAchievements.Remove(0, 1);
            }
            J0x215:
            goto J0xE6;
        }

        if(PendingAchievements.Length <= 0)
        {
            ProcessingAchievements = false;
        }
    }

    else
    {
        PendingAchievements.Length = 0;
        ProcessingAchievements = false;
    }
    OS.PlayerInterface.ClearReadAchievementsCompleteDelegate(byte(PlayerControllerId), InternalOnReadAchievementsComplete);
}

function InternalOnUnlockAchievementComplete(bool bWasSuccessful)
{
    local int PlayerControllerId;

    PlayerControllerId = GetALocalPlayerControllerId();
    PendingAchievements.Remove(0, 1);

    if((OS == none) || EqualEqual_InterfaceInterface(OS.PlayerInterface, (none)))
    {
        return;
    }

    if(PendingAchievements.Length > 0)
    {
        OS.PlayerInterface.AddReadAchievementsCompleteDelegate(byte(PlayerControllerId), InternalOnReadAchievementsComplete);
        OS.PlayerInterface.ReadAchievements(byte(PlayerControllerId));
    }

    else
    {
        OS.PlayerInterface.ClearUnlockAchievementCompleteDelegate(byte(PlayerControllerId), InternalOnUnlockAchievementComplete);
        ProcessingAchievements = false;
    }
}

function int GetALocalPlayerControllerId()
{
    local LocalPlayer LocalPlayer;

    if(PC == none)
    {
        return -1;
    }

    LocalPlayer = LocalPlayer(PC.Player);

    if(LocalPlayer == none)
    {
        return -1;
    }
    return class'UIInteraction'.static.GetPlayerIndex(LocalPlayer.ControllerId);
}
