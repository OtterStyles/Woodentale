using Godot;
using System;

public class Grass : Node2D
{
	private void create_grass_effect()
	{
		var scene = (PackedScene)ResourceLoader.Load("res://Effects/GrassEffect.tscn");
		var grassEffect = (Node2D)scene.Instance();
		var world = GetTree().CurrentScene;
		world.AddChild(grassEffect);
		grassEffect.GlobalPosition = GlobalPosition;
		QueueFree();
	}
	
	public void _on_Hurtbox_area_entered(Area area)
	{
		create_grass_effect();
		QueueFree();
	}

}
