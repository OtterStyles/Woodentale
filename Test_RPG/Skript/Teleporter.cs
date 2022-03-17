using Godot;
using System;

public class Teleporter : Area2D
{
	[Export]
	public PackedScene teleportToScene = (PackedScene)ResourceLoader.Load("res://Wolrd.tscn");
	
	private void onTeleporterBodyEntered(Node2D body)
	{
		if (body.IsInGroup("Player")){
			GetTree().ChangeSceneTo(teleportToScene);
		}
	}
}



