using Godot;

public class Player : Godot.KinematicBody2D
{
	private Vector2 _velocity = Vector2.Zero;
	private Vector2 _roll_Vector = Vector2.Down;
	public PlayerStats _stats = null;

	private const int MAX_SPEED = 80;
	private const int ROLL_SPEED = 125;
	private const int ACCELERATION = 500;
	const int FRICTION = 600;
	private enum PlayerEnum
	{
		MOVE,
		ROLL,
		ATACK
	};

	private AnimationPlayer _animationPlayer = null;
	private AnimationPlayer _blinkAnimationPlayer = null;
	private AnimationTree _animationTree = null;
	private AnimationNodeStateMachinePlayback _animationState = null;
	private PlayerEnum state = PlayerEnum.MOVE;
	private Sword _swordHitbox = null;
	private Hurtbox _hurtbox = null;
	private PackedScene _playerHurtSound = null;
	private PackedScene _deathScene = null;
	
	public override void _Ready()
	{
		_animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		_blinkAnimationPlayer = GetNode<AnimationPlayer>("BlinkAnimationPlayer");
		_animationTree = GetNode<AnimationTree>("AnimationTree");
		_swordHitbox = GetNode<Sword>("HitboxPivot/SwordHitbox");
		_stats = GetNode<PlayerStats>("/root/PlayerStats");
		_hurtbox = GetNode<Hurtbox>("Hurtbox");
		_animationTree.Active = true;
		_animationState = (AnimationNodeStateMachinePlayback)_animationTree.Get("parameters/playback");
		_swordHitbox.knockback_vector = _roll_Vector;
		_stats = GetNode<PlayerStats>("/root/PlayerStats");
		_stats.Connect("noHealth", this, "destroyPlayer");
		_playerHurtSound = ResourceLoader.Load<PackedScene>("res://PreFab/Effects/PlayerHurtSound.tscn");
		_deathScene = ResourceLoader.Load<PackedScene>("res://PreFab/Effects/DeathScene.tscn");
		_onHurtboxInvincibleStoped();
		
	}

	private void destroyPlayer()
	{
		var deathEffect = (Node2D)_deathScene.Instance();
		deathEffect.GlobalPosition = GlobalPosition;
		GetTree().CurrentScene.AddChild(deathEffect);
		QueueFree();
	}


	public override void _PhysicsProcess(float delta)
	{	
		if(Input.IsActionPressed("ui_cancle")){
			GetTree().Paused = !GetTree().Paused;
			
		}
		if (!GetTree().Paused){
			switch (state)
			{
				case PlayerEnum.MOVE: moveState(delta);
					break;
				case PlayerEnum.ROLL:
					roleState(delta);
					break;
				case PlayerEnum.ATACK: attackState(delta);
					break;
			}
		}
	}

	private void moveState(float delta)
	{
		Vector2 inputVector = Vector2.Zero;
		
		inputVector.x = Input.GetActionStrength("ui_right") - Input.GetActionStrength("ui_left");
		inputVector.y = Input.GetActionStrength("ui_down") - Input.GetActionStrength("ui_up");

		inputVector = inputVector.Normalized();
		
		if (inputVector != Vector2.Zero)
		{
			_roll_Vector = inputVector;
			_swordHitbox.knockback_vector = inputVector;
			_animationTree.Set("parameters/Idle/blend_position", inputVector);
			_animationTree.Set("parameters/Run/blend_position", inputVector);
			_animationTree.Set("parameters/Attack/blend_position", inputVector);
			_animationTree.Set("parameters/Roll/blend_position", inputVector);
			_animationState.Travel("Run");
			_velocity = _velocity.MoveToward(inputVector * MAX_SPEED, ACCELERATION * delta);
		}
		else
		{
			_animationState.Travel("Idle");
			_velocity = _velocity.MoveToward(Vector2.Zero, FRICTION * delta);
		}
		move();
		if (Input.IsActionPressed("attack"))
		{
			state = PlayerEnum.ATACK;
		}
		else if (Input.IsActionPressed("roll"))
		{
			state = PlayerEnum.ROLL;
		}
	}

	private void attackState(float delta)
	{
		_velocity = Vector2.Zero;
		_animationState.Travel("Attack");
	}
	private void roleState(float delta)
	{
		_velocity = _roll_Vector * ROLL_SPEED;
		move();
		_animationState.Travel("Roll");
	}

	public void animationFinished()
	{
		_velocity = Vector2.Zero;
		state = PlayerEnum.MOVE;
	}

	private void move()
	{
		_velocity = MoveAndSlide(_velocity);
	}

	public void onHurtboxAreaEntered(Hitbox area)
	{
		_stats.Health -= area.damage;
		_hurtbox.start_invincibillity(0.8f);
		_hurtbox.createHitEffect();
		GetTree().CurrentScene.AddChild(_playerHurtSound.Instance());
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
