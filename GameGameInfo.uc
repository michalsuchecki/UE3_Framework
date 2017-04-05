class GameGameInfo extends FrameworkGame
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var string MapPrefix;
var string MapName;

event InitGame(string Options, out string ErrorMessage)
{
    super(GameInfo).InitGame(Options, ErrorMessage);
    MapName = WorldInfo.GetMapName(true);

    if(InStr(MapName, "uedpc") != -1)
    {
        MapPrefix = "UEDPC";
    }
}

function RestartPlayer(Controller NewPlayer)
{
}

defaultproperties
{
    bRestartLevel=false
    bDelayedStart=false
    bWaitingToStartMatch=true
    PlayerControllerClass=class'GamePlayerController'
    PopulationManagerClass=Class'GameFramework.GameCrowdPopulationManager'
}