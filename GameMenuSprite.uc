class GameMenuSprite extends GameMenuObject;

var Texture2D Image;
var int ImageSize;
var int SpriteSize;
var int SpriteXCount;
var int SpriteYCount;
var float AnimationSpeed;
var float ActualTime;
var int FrameX;
var int FrameY;
var int OffsetX;
var int OffsetY;

function RenderObject(Canvas Canvas, float DeltaTime)
{
    ActualTime += DeltaTime;

    if(ActualTime >= AnimationSpeed)
    {
        ActualTime -= AnimationSpeed;
        ++ FrameX;

        if(FrameX == SpriteXCount)
        {
            FrameX = 0;
            ++ FrameY;

            if(FrameY == SpriteYCount)
            {
                FrameY = 0;
            }
        }
    }

    Canvas.DrawColor = MakeColor(255, 255, 255, 255);
    Canvas.SetPos(Left, Top);
    Canvas.DrawTile(Image, Height, Height, float(OffsetX + (FrameX * SpriteSize)), float(OffsetY + (FrameY * SpriteSize)), float(SpriteSize), float(SpriteSize));
}
