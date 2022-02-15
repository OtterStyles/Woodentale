using Godot;
using System;

public class Hurtbox : Area2D
{
	[Export] public bool showHit = true;
	public PackedScene HitEffect = (PackedScene) ResourceLoader.Load("res://PreFab/Effects/HitEffect.tscn");
	private Timer _timer = null;
	private bool invicible = false;

	public override void _Ready()
	{
		_timer = GetNode<Timer>("Timer");
	}

	[Signal]
	public delegate void invicibleStarted();

	[Signal]
	public delegate void invincibleStoped();

	public bool Invicible
	{
		get
		{
			return invicible;
		}
		set
		{ 
			invicible = value;
			if (invicible)
			{
				EmitSignal("invicibleStarted");
			}
			else
			{
				EmitSignal("invincibleStoped");
			}
		}
	}

	public void start_invincibillity(float duration)
	{
		Invicible = true;
		_timer.Start(duration);	
	}
	public void createHitEffect()
	{
		if(showHit)
		{
			var effect = (Node2D) HitEffect.Instance();
			var main = GetTree().CurrentScene;
			main.AddChild(effect);
			effect.GlobalPosition = GlobalPosition;
		}
	}

	public void _on_Timer_timeout()
	{
		Invicible = false;
	}

	public void _on_Hurtbox_invicibleStarted()
	{
		SetDeferred("Monitorable",false);
	}

	public void _on_Hurtbox_invincibleStoped()
	{
		Monitorable = true;
	}
	
	
}
