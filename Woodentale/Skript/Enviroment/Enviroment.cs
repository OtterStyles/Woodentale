using Godot;
using System;

public class Enviroment : Node2D
{
	[Export(String)]
	public String ItemID = "";
	[Export(String)]
	public String Type = "";
	[Export()]
	public int Hits = 0;
	
	
	public override void _Ready()
	{
		
	}
	
	private void _on_Area2D_body_entered(object body)
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


