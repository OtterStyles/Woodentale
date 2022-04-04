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
	
	private Sprite _sprite = null;
	
	public override void _Ready()
	{
		_sprite = GetNode<Sprite>("Sprite");
	}
	
	private void _on_Area2D_body_entered(Node2D body)
	{
		if (body.IsInGroup(Type)){
			Hits -= 1;
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


