using Godot;
using System;

public class Enviroment : Node2D
{
	[Export()]
	public String ItemID = "";
	[Export()]
	public String Type = "";
	[Export()]
	public int Hits = 0;
	
	
	public override void _Ready()
	{
		
	}
	
	private void _on_Area2D_body_entered(Node2D body)
	{
		if (body.isInGroup(Type)){
			Hits -= body.Strength;
			if (Hits < 0){
				dropItem();
				QueueFree();
			}
		}
	}
	
	private void dropItem()
	{
		
	}
	
	
}


