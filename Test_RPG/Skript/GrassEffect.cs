using Godot;
using System;

public class GrassEffect : Node2D
{
	private AnimatedSprite _animatedSprite = null;
	public override void _Ready()
	{
		_animatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");
		_animatedSprite.Frame = 0;
		_animatedSprite.Play("Animate");
		
	}
	
	public void animationFinished()
	{
		QueueFree();
	}
	
}
