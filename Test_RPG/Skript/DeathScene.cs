using Godot;
using System;

public class DeathScene : Node2D{
    
    private PackedScene _startScene = (PackedScene)ResourceLoader.Load("res://MainMenu.tscn");
    
    public void _on_Timer_timeout()
    {
        QueueFree();
        GetTree().ChangeSceneTo(_startScene);
    }
}
