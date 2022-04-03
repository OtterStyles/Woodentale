using Godot;
using System;

public class Player : Godot.KinematicBody2D
{
	Vector2 _velocity = Vector2.Zero;
	private const int MAX_SPEED = 80;
	private const int MAX_SPEED_SPRINT = 160;	
	private const int ACCELERATION = 500;
	const int FRICTION = 600;
	
	private AnimationPlayer _animationPlayer = null;
	private AnimationTree _animationTree = null;
	private AnimationNodeStateMachinePlayback _animationState = null;
	private PlayerStats _stats = null;
	private Sprite _sprite = null;
	
	public override void _Ready()
	{
		_animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		_animationTree = GetNode<AnimationTree>("AnimationTree");
		_animationState = (AnimationNodeStateMachinePlayback)_animationTree.Get("parameters/playback");
		_sprite = GetNode<Sprite>("Sprite");
		_stats = GetNode<PlayerStats>("/root/PlayerStats");
		_stats.Connect("noHealth", this, "destroyPlayer");
	}

	private void destroyPlayer()
	{
		QueueFree();
	}
	public override void _PhysicsProcess(float delta)
	{
		Vector2 inputVector = Vector2.Zero;
		inputVector.x = Input.GetActionStrength("ui_right") - Input.GetActionStrength("ui_left");
		inputVector.y = Input.GetActionStrength("ui_down") - Input.GetActionStrength("ui_up");
		var sprint = Input.GetActionStrength("sprint");
		_animationTree.Set("parameters/IDLE/blend_position", inputVector);
		_animationTree.Set("parameters/GOING/blend_position", inputVector);
		_animationTree.Set("parameters/RUNNING/blend_position", inputVector);

		inputVector = inputVector.Normalized();
		flipThePlayer(inputVector);
		if ((inputVector != Vector2.Zero)&&(sprint == 0))
		{
			_animationState.Travel("GOING");
			_velocity = _velocity.MoveToward(inputVector * MAX_SPEED, ACCELERATION * delta);
		}
		else if ((inputVector != Vector2.Zero)&&(sprint == 1))
		{
			_animationState.Travel("RUNNING");
			_velocity = _velocity.MoveToward(inputVector * MAX_SPEED_SPRINT, ACCELERATION * delta);
		}
		else
		{
			_animationState.Travel("IDLE");
			_velocity = _velocity.MoveToward(Vector2.Zero, FRICTION * delta);
		}
		_velocity = MoveAndSlide(_velocity);
		
	}

	private void flipThePlayer(Vector2 inputVector)
	{
		if (inputVector.x < 0)
		{
			_sprite.FlipH = true;
		}
		else
		{
			_sprite.FlipH = false;
		}
	}
}
