class GameCamera extends Camera
    transient
    hidecategories(Navigation);

private final function FadeTo(float DeltaTime, float FadeFrom, float FadeTo)
{
    bEnableFading = true;
    FadeTimeRemaining = DeltaTime;
    FadeTime = DeltaTime;
    FadeAlpha.X = FadeFrom;
    FadeAlpha.Y = FadeTo;
}

function bool IsCameraFading()
{
    return bEnableFading;
}

function FadeToBlack(float DeltaTime)
{
    FadeTo(DeltaTime, 0.0, 1.0);
}

function FadeToNormal(float DeltaTime)
{
    FadeTo(DeltaTime, 1.0, 0.0);
}
