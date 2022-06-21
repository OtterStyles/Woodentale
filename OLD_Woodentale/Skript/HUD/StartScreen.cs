using Godot;
using System;

public class StartScreen : Control
{
	private Control options;
	public PackedScene StartScene = ResourceLoader.Load<PackedScene>("res://Scene/Farm.tscn");
	
	public override void _Ready(){
		options = GetNode<Control>("MarginContainer/Options");
	}

	public void _on_Start_pressed()
	{
		GetTree().ChangeSceneTo(StartScene);
	}

	public void _on_Options_pressed()
	{
		options.Visible = true;
	}

	public void _on_Exit_pressed()
	{
		GetTree().Quit(1);
	}
}
