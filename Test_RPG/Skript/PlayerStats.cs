using Godot;
using System;

public class PlayerStats : Stats
{
	[Signal]
	public delegate void killsChanged(int value);
	private int kills = 0;

	public int Kills
	{
		get => kills;
		set 
		{
			kills = value;
			EmitSignal("killsChanged", kills);
		}
	}
}
