using Godot;
using System;

public class Stats : Node
{ 
	[Export(PropertyHint.Range,"0,100,")]
	public int max_health = 1;
	private int health = 1;

	[Signal]
	public delegate void noHealth();
	[Signal]
	public delegate void healthChanged(int value);
	[Signal]
	public delegate void maxHealthChanged(int value);

	public override void _Ready()
	{
		health = max_health;
	}
	
	
	public int Health
	{
		get
		{
			return health;
		}
		set
		{
			health = value;
			EmitSignal("healthChanged", health);
			if(health <= 0)
			{
				
				EmitSignal("noHealth");
			}
		}

	}

	public int MaxHealth
	{
		get => max_health;
		set
		{
			max_health = value;
			Health = Mathf.Min(Health, max_health);
			EmitSignal("maxHealthChanged", value);
		}
	}
}
