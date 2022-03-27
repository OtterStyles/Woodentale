using Godot;
using System;
using System.Collections;


public class Bat : KinematicBody2D
{
	[Export] public int ACCELERATION = 300;
	[Export] public int MAX_SPEED = 50;
	[Export] public int FRICTION = 200;
		
	public PackedScene EnemyDeathEffect = (PackedScene) ResourceLoader.Load("res://Prefab/Effects/EnemyDeathEffect.tscn");
	private enum BatEnum
	{
		IDLE,
		WANDER,
		CHASE
	};

	private BatEnum state = BatEnum.IDLE;
	
	Vector2 knockback = Vector2.Zero;
	private Vector2 velocity = Vector2.Zero;
	private Stats _stats = null;
	private PlayerDetectionZone _playerDetectionZone = null;
	private AnimatedSprite _animatedSprite = null;
	private Hurtbox _hurtbox = null;
	private SoftCollision _softCollision = null;
	private WanderController _wanderController = null;
	private AnimationPlayer _blinkAnimationPlayer = null;
	
	public override void _Ready()
	{
		_stats = GetNode<Stats>("Stats");
		_playerDetectionZone = GetNode<PlayerDetectionZone>("PlayerDetection");
		_animatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");
		_hurtbox = GetNode<Hurtbox>("Hurtbox");
		_softCollision = GetNode<SoftCollision>("SoftCollision");
		_wanderController = GetNode<WanderController>("WanderController");
		_blinkAnimationPlayer = GetNode<AnimationPlayer>("BlinkAnimationPlayer");
		updateWanderState();
	}

	public override void _PhysicsProcess(float delta)
	{
		knockback = knockback.MoveToward(Vector2.Zero, FRICTION * delta);
		knockback = MoveAndSlide(knockback);
		switch (state)
		{
			case BatEnum.IDLE:
				velocity = velocity.MoveToward(Vector2.Zero, FRICTION * delta);
				seekPlayer();
				checkPlayer();
				break;
			case BatEnum.CHASE:
				chasePlayer(delta);
				break;
			case BatEnum.WANDER: 
				seekPlayer();
				checkPlayer();
				wanderState(delta);
				break;
		}
		velocity += _softCollision.getPushVector() * delta * MAX_SPEED * 100;
		velocity = MoveAndSlide(velocity);

	}

	public void checkPlayer()
	{
		if (_wanderController.getTimeLeft() == 0)
		{
			updateWanderState();
		}
	}

	public void chasePlayer(float delta)
	{
		var player = _playerDetectionZone.player;
		if (player != null)
		{
			accelerateTowardsPoint(player.GlobalPosition, delta);
		}
		else
		{
			state = BatEnum.IDLE;
		}
		_animatedSprite.FlipH = velocity.x < 0;
	}

	public void wanderState(float delta)
	{
		accelerateTowardsPoint(_wanderController.TargetPosition, delta);
		if (GlobalPosition.DistanceTo(_wanderController.TargetPosition) <= MAX_SPEED*delta)
		{
			updateWanderState();
			_animatedSprite.FlipH = velocity.x < 0;
		}
	}

	private void updateWanderState()
	{
		
		state = (BatEnum) pickNewState(new ArrayList() {BatEnum.IDLE, BatEnum.WANDER});
		_wanderController.startWanderTimer(new Random().Next(1, 3));
	}
	
	private void accelerateTowardsPoint(Vector2 point, float delta)
	{
		
		var direction = GlobalPosition.DirectionTo(point);
		velocity = velocity.MoveToward(direction * MAX_SPEED, ACCELERATION*delta);
	}
	
	public void seekPlayer()
	{
		if (_playerDetectionZone.canSeePlayer())
		{
			state = BatEnum.CHASE;
		}
	}

	public object pickNewState(ArrayList stateList)
	{
		Random random = new Random();
		int randomInt = random.Next(0, stateList.Count);
		return stateList[randomInt];
	}
	
	public void onHurtboxAreaEntered(Sword area)
	{
		_stats.Health -= area.damage;
		knockback = area.knockback_vector * 140;
		_hurtbox.start_invincibillity(0.1f);
		_hurtbox.createHitEffect();
		_hurtbox.start_invincibillity(0.2f);
		
	}

	public void _on_Stats_noHealth()
	{
		QueueFree();
		var enemyDeathEffect = (Node2D)EnemyDeathEffect.Instance();
		GetParent().AddChild(enemyDeathEffect);
		enemyDeathEffect.GlobalPosition = GlobalPosition;
	}
	public void _onHurtboxInvicibleStarted()
	{
		_blinkAnimationPlayer.Play("Start");
	}

	public void _onHurtboxInvincibleStoped()
	{
		_blinkAnimationPlayer.Play("Stop");
	}
}
