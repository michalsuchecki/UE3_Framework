class GamePlayerInput extends MobilePlayerInput within GamePlayerController
    transient
    config(Game)
    hidecategories(Object,UIRoot);

var bool OldRenderQueueForward;

function MobileMenuScene GameOpenMenuScene(class<MobileMenuScene> SceneClass, optional string Mode, optional float NewWidth, optional float NewHeight, optional float NewPaddingX, optional float NewPaddingY, optional GameScene OwnerToSet)
{
    local MobileMenuScene Scene;
    local Vector2D ViewportSize;

    NewWidth = 0.0;
    NewHeight = 0.0;
    NewPaddingX = 0.0;
    NewPaddingY = 0.0;    

    if(SceneClass != none)
    {
        Scene = new (Outer) SceneClass;

        if(Scene != none)
        {
            LocalPlayer(Outer.Player).ViewportClient.GetViewportSize(ViewportSize);

            if((GameScene(Scene) != none) && OwnerToSet != none)
            {
                GameScene(Scene).Owner = OwnerToSet;
            }

            if(NewHeight != 0.0)
            {
                Scene.Height = NewHeight;
            }

            if(NewWidth != 0.0)
            {
                Scene.Width = NewWidth;
            }

            if(NewPaddingX != 0.0)
            {
                GameScene(Scene).Padding.X = NewPaddingX;
            }

            if(NewPaddingY != 0.0)
            {
                GameScene(Scene).Padding.Y = NewPaddingY;
            }

            Scene.InitMenuScene(self, int(ViewportSize.X), int(ViewportSize.Y), true);
            MobileMenuStack.InsertItem(0, Scene);
            Scene.Opened(Mode);
            Scene.MadeTopMenu();
            MobileMenuStack.Sort(SortLayers);
            return Scene;
            J0x323:
        }
        else
        {
        }
    }
    return none;
}

function int SortLayers(MobileMenuScene Scene0, MobileMenuScene Scene1)
{
    local GameScene GameScene0, GameScene1;

    GameScene0 = GameScene(Scene0);
    GameScene1 = GameScene(Scene1);

    if((GameScene0 == none) || GameScene1 == none)
    {
        return 0;
    }

    return ((GameScene0.RenderLayer < GameScene1.RenderLayer) ? -1 : 0);
}

exec function DebugStackArray()
{
    local MobileMenuScene DebugScene;
    local GameScene DebugGameScene;
    local int NameLen, Idx, Idx2;
    local string DebugText;

    foreach MobileMenuStack(DebugScene, Idx2)
    {
        DebugGameScene = GameScene(DebugScene);
        NameLen = Len(string(DebugGameScene));
        NameLen = 40 - NameLen;
        DebugText = ("--->>> " @ string(Idx2)) @ string(DebugGameScene);
        Idx = 0;

        J0xA1:
        if(Idx < NameLen)
        {
            DebugText $= " ";
            ++ Idx;
            goto J0xA1;
        }
        DebugText $= string(DebugGameScene.RenderLayer);        
    }    
}