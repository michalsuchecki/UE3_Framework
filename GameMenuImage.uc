class GameMenuImage extends GameMenuObject;

enum MenuImageDrawStyle
{
    IDS_Normal,
    IDS_Stretched,
    IDS_Tile,
    IDS_MAX
};

var Texture2D Image;
var UVCoords ImageUVs;
var MenuImageDrawStyle ImageDrawStyle;
var LinearColor ImageColor;
var LinearColor ClickImageColor;
var bool bIsInitialized;
var float W;
var float H;
var float U;
var float V;
var float UL;
var float VL;

function Initialize(Canvas Canvas)
{
    if(ImageUVs.bCustomCoords)
    {
        U = ImageUVs.U;
        V = ImageUVs.V;
        UL = ImageUVs.UL;
        VL = ImageUVs.VL;
    }
    else
    {
        U = 0.0;
        V = 0.0;
        UL = float(Image.SizeX);
        VL = float(Image.SizeY);
    }

    switch(ImageDrawStyle)
    {
        case 0:
            W = ((Width > UL) ? UL : Width);
            H = ((Height > VL) ? VL : Height);
            UL = W;
            VL = H;
            break;
        case 1:
            W = Width;
            H = Height;
            break;
        case 2:
            W = Width;
            H = Height;
            UL = W;
            VL = H;
            break;
        default:
            bIsInitialized = true;
    }    
}

event bool OnTouch(Engine.Interaction.ETouchType EventType, float TouchX, float TouchY, MobileMenuObject ObjectOver, float DeltaTime)
{
    if(GameOwner == none)
    {
        return false;
    }

    switch(EventType)
    {
        case 3:
        case 4:
            if(!bIsTouched)
            {
                GameOwner.OnTouch(self, EventType, TouchX, TouchY);
            }
            return !bIsTouched;
        default:
            return false;
    }
}

function SetNewUVs(UVCoords NewUVs)
{
    ImageUVs = NewUVs;
    bIsInitialized = false;
}

function RenderObject(Canvas Canvas, float DeltaTime)
{
    local LinearColor DrawColor;

    super.RenderObject(Canvas, DeltaTime);

    if(Image != none)
    {
        if(!bIsInitialized)
        {
            Initialize(Canvas);
        }
        SetCanvasPos(Canvas);
        DrawColor = ((bIsTouched) ? ClickImageColor : ImageColor);
        DrawColor.A *= (Opacity * OwnerScene.Opacity);
        Canvas.DrawTile(Image, W, H, U, V, UL, VL, DrawColor);
    }
}

defaultproperties
{
    ImageColor=(R=1.0,G=1.0,B=1.0,A=1.0)
    ClickImageColor=(R=1.0,G=1.0,B=1.0,A=1.0)
}