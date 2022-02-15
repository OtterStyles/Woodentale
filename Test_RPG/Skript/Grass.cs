using Godot;
using System;

public class Grass : Node2D
{
	public PackedScene GrassEffect = (PackedScene)ResourceLoader.Load("res://Prefab/Effects/GrassEffect.tscn");
	private void create_grass_effect()
	{
		var grassEffect = (Node2D)GrassEffect.Instance();
		GetParent().AddChild(grassEffect);
		grassEffect.GlobalPosition = GlobalPosition;
		QueueFree();
	}
	
	public void _on_Hurtbox_area_entered(Area area)
	{
		create_grass_effect();
		QueueFree();
	}

}
