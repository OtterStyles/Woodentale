using Godot;
using System;

public class Player : Godot.KinematicBody2D
{
	Vector2 _velocity = Vector2.Zero;
	private const int MAX_SPEED = 80;
	private const int ACCELERATION = 500;
	const int FRICTION = 600;
	private enum PlayerEnum
	{
		MOVE,
		ROLL,
		ATACK
	};

	private AnimationPlayer _animationPlayer = null;
	private AnimationTree _animationTree = null;
	private AnimationNodeStateMachinePlayback _animationState = null;
	private PlayerEnum state = PlayerEnum.MOVE;
	
	public override void _Ready()
	{
		
		_animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		_animationTree = GetNode<AnimationTree>("AnimationTree");
		_animationTree.Active = true;
		_animationState = (AnimationNodeStateMachinePlayback)_animationTree.Get("parameters/playback");
	}
	
	
	public override void _PhysicsProcess(float delta)
	{
		Vector2 inputVector = Vector2.Zero;
		inputVector.x = Input.GetActionStrength("ui_right") - Input.GetActionStrength("ui_left");
		inputVector.y = Input.GetActionStrength("ui_down") - Input.GetActionStrength("ui_up");

		inputVector = inputVector.Normalized();
		
		if (inputVector != Vector2.Zero)
		{
			_animationTree.Set("parameters/Idle/blend_position", inputVector);
			_animationTree.Set("parameters/Run/blend_position", inputVector);
			_animationState.Travel("Run");
			_velocity = _velocity.MoveToward(inputVector * MAX_SPEED, ACCELERATION * delta);
		}
		else
		{
			_animationState.Travel("Idle");
			_velocity = _velocity.MoveToward(Vector2.Zero, FRICTION * delta);
		}
		_velocity = MoveAndSlide(_velocity);
		
	}
}
