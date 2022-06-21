using Godot;
using System;

public class PlayerStats : Stats
{
    public int Wood
	{
		get
		{
			return Wood;
		}
		set
		{
			Wood = value;
			EmitSignal("itemChanged", Wood);
		}

	}
    [Signal]
	public delegate void itemChanged(int value);
	
}
