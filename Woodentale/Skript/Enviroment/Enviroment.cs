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
	
	
	private void _on_Area2D_area_entered(Area2D area){
		if (area.IsInGroup(Type)){
			Hits -= 1;
			if (Hits <= 0){
				dropItem();
				QueueFree();
			}
		}
	}


	private void dropItem()
	{
		GD.Print("Dropped Item");
	}
	
	
}


