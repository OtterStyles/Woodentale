using Godot;
using System;

public class Stats : Node
{
		public int Health
	{
		get
		{
			return Health;
		}
		set
		{
			Health = value;
			EmitSignal("healthChanged", Health);
			if(Health <= 0)
			{
				
				EmitSignal("noHealth");
			}
		}

	}

	[Export()] public int MaxHealth
	{
		get => MaxHealth;
		set
		{
			MaxHealth = value;
			Health = Mathf.Min(Health, MaxHealth);
			EmitSignal("maxHealthChanged", value);
		}
	}
	
	[Signal]
	public delegate void noHealth();
	[Signal]
	public delegate void healthChanged(int value);
	[Signal]
	public delegate void maxHealthChanged(int value);
	
	
	
	public override void _Ready()
	{
		
	}
	
}
