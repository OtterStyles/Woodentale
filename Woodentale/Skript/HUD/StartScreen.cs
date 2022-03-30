using Godot;
using System;

public class StartScreen : Control
{
	public PackedScene OptionsGUI = ResourceLoader.Load<PackedScene>("res://Menu/Options.tscn");
	public PackedScene StartScene = ResourceLoader.Load<PackedScene>("res://Scene/TestHub.tscn");
	private Options _options = null;
	
	public override void _Ready()
	{
		_options = GetNode<Options>("MarginContainer/Options");
	}

	public void _on_Start_pressed()
	{
		GetTree().ChangeSceneTo(StartScene);
	}

	public void _on_Options_pressed()
	{
		_options.Visible = true;
	}

	public void _on_Exit_pressed()
	{
		GetTree().Quit(1);
	}
}
