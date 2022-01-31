using Godot;
using System;

public class GrassEffect : Node2D
{
	private AnimatedSprite _animatedSprite = null;
	public override void _Ready()
	{
		_animatedSprite = GetParent().GetNode<AnimatedSprite>("AnimatedSprite");
		_animatedSprite.Frame = 0;
		_animatedSprite.Play("Animate");
	}

	public void _on_AnimatedSprite_animation_finished()
	{
		QueueFree();
	}
	
}
