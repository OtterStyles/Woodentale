using Godot;
using System;

public class Grass : Node2D
{
	private Sprite sprite = null; 
	private Node2D grassEffect = null;
	private PackedScene scene = null;

	public override void _Ready()
	{
		scene = (PackedScene)ResourceLoader.Load("res://Effects/GrassEffect.tscn");
		grassEffect = (Node2D)scene.Instance();
		sprite = GetNode<Sprite>("Sprite");
	}

	public override void _Process(float delta)
	{
		if (Input.IsActionPressed("attack"))
		{
			sprite.QueueFree();
			AddChild(grassEffect);
		}     

	}

}
