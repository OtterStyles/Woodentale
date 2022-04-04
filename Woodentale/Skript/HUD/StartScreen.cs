using Godot;
using System;

public class StartScreen : Control
{
    public PackedScene OptionsGUI = ResourceLoader.Load<PackedScene>("res://Menu/Options.tscn");
    public PackedScene StartScene = ResourceLoader.Load<PackedScene>("res://Scene/Farm.tscn");


    public void _on_Start_pressed()
    {
        GetTree().ChangeSceneTo(StartScene);
    }

    public void _on_Options_pressed()
    {
        GetTree().ChangeSceneTo(OptionsGUI);
    }

    public void _on_Exit_pressed()
    {
        GetTree().Quit(1);
    }
}
