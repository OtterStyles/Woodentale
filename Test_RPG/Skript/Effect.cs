using Godot;
using System;

public class Effect : AnimatedSprite
{

	public override void _Ready()
	{
		Connect("animation_finished", this, "onAnimationFinished");
		Frame = 0;
		Play("Animate");
		
	}
	
	public void onAnimationFinished()
	{
		QueueFree();
	}
	
}
