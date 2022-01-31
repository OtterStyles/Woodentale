using Godot;
using System;

public class Grass : Node2D
{
  private GrassEffect _grassEffect = null;
  private Node _world = null;

  public override void _Ready()
  {
	_grassEffect = new GrassEffect();
	_world = GetTree().CurrentScene;
  }


  public override void _Process(float delta)
  {
	if (Input.IsActionPressed("attack"))
	{
	   _world.AddChild(_grassEffect);
	   _grassEffect.GlobalPosition = GlobalPosition;
	  QueueFree();
	}     
  }
}
