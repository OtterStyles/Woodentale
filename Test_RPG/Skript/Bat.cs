using Godot;
using System;
using System.Drawing.Printing;
using System.Linq;
using Godot.Collections;
using Array = System.Array;
using Object = Godot.Object;


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
	public override void _Ready()
	{
		_stats = GetNode<Stats>("Stats");
		_playerDetectionZone = GetNode<PlayerDetectionZone>("PlayerDetection");
		_animatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");
		_hurtbox = GetNode<Hurtbox>("Hurtbox");
		_softCollision = GetNode<SoftCollision>("SoftCollision");
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
				break;
			case BatEnum.CHASE:
				chasePlayer(delta);
				break;
			case BatEnum.WANDER: 
				break;
		}
		velocity += _softCollision.getPushVector() * delta * MAX_SPEED * 100;
		velocity = MoveAndSlide(velocity);

	}

	public void chasePlayer(float delta)
	{
		var player = _playerDetectionZone.player;
		if (player != null)
		{
			var direction = (player.GlobalPosition - GlobalPosition).Normalized();
			velocity = velocity.MoveToward(direction * MAX_SPEED, ACCELERATION*delta);
					
		}
		else
		{
			state = BatEnum.IDLE;
		}
		_animatedSprite.FlipH = velocity.x < 0;
	}
	
	public void seekPlayer()
	{
		if (_playerDetectionZone.canSeePlayer())
		{
			state = BatEnum.CHASE;
		}
	}

	
	public void onHurtboxAreaEntered(Sword area)
	{
		_stats.Health -= area.damage;
		knockback = area.knockback_vector * 140;
		_hurtbox.start_invincibillity(0.1f);
		_hurtbox.createHitEffect();
	}

	public void _on_Stats_noHealth()
	{
		QueueFree();
		var enemyDeathEffect = (Node2D)EnemyDeathEffect.Instance();
		GetParent().AddChild(enemyDeathEffect);
		enemyDeathEffect.GlobalPosition = GlobalPosition;
	}

}
