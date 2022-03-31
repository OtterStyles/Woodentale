using Godot;
using System;

public class MarginContainer : Godot.MarginContainer
{
	private Control _HUD = null;
	private Control _Pause = null;
	public override void _Ready()
	{
		_HUD = GetNode<Control>("MarginContainer/HUD");
		_Pause = GetNode<Control>("MarginContainer/Pause");     
		_Pause.Visible = false; 
	}
	
	public override void _Input(event)
	{
		if (event.isActionPressed("ui_cancel")){
			GetTree().Paused = !GetTree().Paused;
			if (GetTree().Paused){
				_Pause.Visible = true;
			}else{
				_Pause.Visible = false; 
			}
		}
	}
}
