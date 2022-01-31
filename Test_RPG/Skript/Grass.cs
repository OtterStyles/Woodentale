using Godot;
using System;

public class Grass : Node2D
{
	private AnimatedSprite _animatedSprite = null;
	private Sprite _sprite = null;

	public override void _Ready()
	{
		_animatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");
		_sprite = GetNode<Sprite>("Sprite");
		RemoveChild(_animatedSprite);
	}


	public override void _Process(float delta)
	{
		if (Input.IsActionPressed("attack"))
		{
			RemoveChild(_sprite);
			AddChild(_animatedSprite);
			_animatedSprite.Frame = 0;
			_animatedSprite.Play("Animate");
		}     

	}

	public void animationFinished()
	{
		QueueFree();
	}
}
