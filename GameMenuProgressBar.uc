class GameMenuProgressBar extends GameMenuObject;

var Texture2D FrameTex;
var UVCoords FrameUVs;
var UVCoords BarUVs;
var Vector2D BarOffset;
var Vector2D BarPadding;
var Vector2D CurBarOffset;
var Vector2D CurBarPadding;
var float MaxValue;
var float CurValue;

function InitMenuObject(MobilePlayerInput PlayerInput, MobileMenuScene Scene, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
    super.InitMenuObject(PlayerInput, Scene, ScreenWidth, ScreenHeight, bIsFirstInitialization);

    if(bIsFirstInitialization)
    {
        CurBarOffset.X = BarOffset.X * Width;
        CurBarOffset.Y = BarOffset.Y * Height;
        CurBarPadding.X = BarPadding.X * Width;
        CurBarPadding.Y = BarPadding.Y * Height;
    }
}

function SetMaxValue(float Value)
{
    MaxValue = Value;
}

function SetCurValue(float Value)
{
    CurValue = FClamp(Value, 0.0, MaxValue);
}

function RenderObject(Canvas Canvas, float DeltaTime)
{
    local float Value, ValueSize;

    super.RenderObject(Canvas, DeltaTime);
    Canvas.DrawColor = MakeColor(255, 255, 255, byte(float(255) * OwnerScene.Opacity));

    if(MaxValue > float(0))
    {
        Value = CurValue / MaxValue;
        ValueSize = (Height - (CurBarOffset.Y * float(2))) * Value;
        SetCanvasPos(Canvas, CurBarOffset.X + CurBarPadding.X, (Height - ValueSize) - CurBarOffset.Y);
        Canvas.DrawTile(FrameTex, Width - (CurBarOffset.X * float(2)), ValueSize, BarUVs.U, BarUVs.V + (BarUVs.VL - (BarUVs.VL * Value)), BarUVs.UL, BarUVs.VL * Value);
    }
    Canvas.DrawColor = MakeColor(255, 255, 255, byte(float(255) * OwnerScene.Opacity));
    SetCanvasPos(Canvas);
    Canvas.DrawTile(FrameTex, Width, Height, FrameUVs.U, FrameUVs.V, FrameUVs.UL, FrameUVs.VL);
}

defaultproperties
{
    MaxValue=100.0
    CurValue=100.0
}