class GameMenuPanel extends GameMenuObject;

var export editinline array<export editinline GameMenuObject> Objects;

function InitMenuObject(MobilePlayerInput PlayerInput, MobileMenuScene Scene, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
    local GameMenuObject ObjectToInit;
    local int SceneWidth, SceneHeight, SceneLeft, SceneTop;

    super.InitMenuObject(PlayerInput, Scene, ScreenWidth, ScreenHeight, bIsFirstInitialization);

    if(bIsFirstInitialization)
    {
        SceneWidth = int(Scene.Width);
        SceneHeight = int(Scene.Height);
        SceneLeft = int(Scene.Left);
        SceneTop = int(Scene.Top);
        Scene.Width = Width;
        Scene.Height = Height;
        Scene.Left = Left;
        Scene.Top = Top;

        foreach Objects(ObjectToInit,)
        {
            ObjectToInit.InitMenuObject(PlayerInput, Scene, ScreenWidth, ScreenHeight, bIsFirstInitialization);
            ObjectToInit.bPanelElement = true;
            ObjectToInit.Top += Top;
            ObjectToInit.Left += Left;
            Scene.MenuObjects.AddItem(ObjectToInit);            
        }        
        Scene.Width = float(SceneWidth);
        Scene.Height = float(SceneHeight);
        Scene.Left = float(SceneLeft);
        Scene.Top = float(SceneTop);
    }

}

function SetHidden(bool bHidden)
{
    local GameMenuObject MenuObject;

    foreach Objects(MenuObject,)
    {
        MenuObject.bIsHidden = bHidden;        
    }    
}

function RenderObject(Canvas Canvas, float DeltaTime)
{
    if(bIsHidden)
    {
        return;
    }

    if(bShowDebug)
    {
        OnDebugDraw(Canvas, DeltaTime);
    }
}

defaultproperties
{
    Width=1.0
    Height=1.0
    Tag="PANEL"
}