class GameProjectile extends Projectile
    hidecategories(Navigation);

var(Projectile) float AccelRate;
var bool bShuttingDown;
var(Projectile) bool bInitOnSpawnWithRotation;
var bool bSuppressExplosionFX;
var export editinline ParticleSystemComponent ProjEffects;
var(Projectile) ParticleSystem ProjFlightTemplate;
var(Projectile) ParticleSystem ProjExplosionTemplate;
var(Projectile) float MaxEffectDistance;
var(Projectile) SoundCue ExplosionSound;
var(Projectile) array< class<Actor> > ActorsToIgnoreWhenHit;

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
    HitWall(HitNormal, FloorActor, none);
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if(bDeleteMe || bShuttingDown)
    {
        return;
    }
    SpawnFlightEffects();

    if(bInitOnSpawnWithRotation)
    {
        Init(vector(Rotation));
    }
}

simulated event SetInitialState()
{
    bScriptInitialized = true;

    if((Role < ROLE_Authority) && AccelRate != 0.0)
    {
        GotoState('WaitingForVelocity');
    }
    else
    {
        GotoState(((InitialState != 'None') ? InitialState : 'Auto'));
    }
}

function Init(Vector Direction)
{
    SetRotation(rotator(Direction));
    Velocity = Speed * Direction;
    Acceleration = AccelRate * Normal(Velocity);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    if(ActorsToIgnoreWhenHit.Find(Other.Class) != -1)
    {
        return;
    }
    if(DamageRadius > 0.0)
    {
        Explode(HitLocation, HitNormal);
    }
    else
    {
        PlaySound(ImpactSound);
        Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
        ShutDown();
    }
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    if((Damage > float(0)) && DamageRadius > float(0))
    {
        if(Role == ROLE_Authority)
        {
            MakeNoise(1.0);
        }
        if(!bShuttingDown)
        {
            ProjectileHurtRadius(HitLocation, HitNormal);
        }
        SpawnExplosionEffects(HitLocation, HitNormal);
    }
    else
    {
        PlaySound(ImpactSound);
    }
    ShutDown();
}

simulated function SpawnFlightEffects()
{
    if((WorldInfo.NetMode != NM_DedicatedServer) && ProjFlightTemplate != none)
    {
        ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjFlightTemplate, true);
        ProjEffects.SetAbsolute(false, false, false);
        ProjEffects.SetLODLevel(((WorldInfo.bDropDetail) ? 1 : 0));
        ProjEffects.__OnSystemFinished__Delegate = MyOnParticleSystemFinished;
        ProjEffects.bUpdateComponentInTick = true;
        ProjEffects.SetTickGroup(4);
        AttachComponent(ProjEffects);
        ProjEffects.ActivateSystem(true);
    }

    if(SpawnSound != none)
    {
        PlaySound(SpawnSound);
    }
}

simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
}

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
    local editinline ParticleSystemComponent ProjExplosion;
    local Actor EffectAttachActor;

    if(WorldInfo.NetMode != NM_DedicatedServer)
    {
        if(EffectIsRelevant(Location, false, MaxEffectDistance))
        {
            if(ProjExplosionTemplate != none)
            {
                EffectAttachActor = ImpactedActor;
                ProjExplosion = WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionTemplate, HitLocation, rotator(HitNormal), EffectAttachActor);
                SetExplosionEffectParameters(ProjExplosion);
            }
            if(ExplosionSound != none)
            {
                PlaySound(ExplosionSound, true);
            }
        }
        bSuppressExplosionFX = true;
    }
}

simulated function ShutDown()
{
    local Vector HitLocation, HitNormal;

    bShuttingDown = true;
    HitNormal = Normal(Velocity * float(-1));
    Trace(HitLocation, HitNormal, Location + (HitNormal * float(-32)), Location + (HitNormal * float(32)), true, vect(0.0, 0.0, 0.0));
    SetPhysics(0);

    if(ProjEffects != none)
    {
        ProjEffects.DeactivateSystem();
    }

    HideProjectile();
    SetCollision(false, false);
    Destroy();
}

event TornOff()
{
    ShutDown();
    super(Actor).TornOff();
}

simulated function HideProjectile()
{
    local editinline MeshComponent ComponentIt;

    foreach ComponentList(class'MeshComponent', ComponentIt)
    {
        ComponentIt.SetHidden(true);        
    }    
}

simulated function Destroyed()
{
    if(ProjEffects != none)
    {
        DetachComponent(ProjEffects);
        WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
        ProjEffects = none;
    }
    super(Actor).Destroyed();
}

simulated function MyOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    if(PSC == ProjEffects)
    {
        DetachComponent(ProjEffects);
        WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
        ProjEffects = none;
    }
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    out_CamLoc = Location + (CylinderComponent.CollisionHeight * vect(0.0, 0.0, 1.0));
    return true;
}

simulated function Pawn GetPawnOwner()
{
}

state WaitingForVelocity
{
    simulated function Tick(float DeltaTime)
    {
        if(!UnresolvedNativeFunction_101(Velocity))
        {
            Acceleration = AccelRate * Normal(Velocity);
            GotoState(((InitialState != 'None') ? InitialState : 'Auto'));
        }
    }
    stop;    
}

defaultproperties
{
    AccelRate=15000.0
    bInitOnSpawnWithRotation=true
    MaxSpeed=5000.0
    Damage=10.0
    DamageRadius=0.0
    MomentumTransfer=500.0
    begin object name=CollisionCylinder class=CylinderComponent
        ReplacementPrimitive=none
    object end

    DrawScale=2.0
    LifeSpan=2.0

    CollisionComponent=CollisionCylinder
    CylinderComponent=CollisionCylinder
    Components(0)=CollisionCylinder
}