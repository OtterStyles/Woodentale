using Godot;
using System;

public class Options : Control
{
	private ScrollContainer _Audio = null;
	private ScrollContainer _Video = null;
	private ScrollContainer _Controll = null;
	
	
	public override void _Ready()
	{
		_Audio = GetNode<ScrollContainer>("MarginContainer/VBoxContainer/Controlls/Audio");
		_Video = GetNode<ScrollContainer>("MarginContainer/VBoxContainer/Controlls/Video");
		_Controll = GetNode<ScrollContainer>("MarginContainer/VBoxContainer/Controlls/Controls");
		hideOptions();
		_Audio.Visible = true;
		this.Visible = false;
	}
	private void _on_Menue_pressed()
	{
		this.Visible = false;
	}
	
	private void _on_Audio_pressed()
	{
		hideOptions();
		_Audio.Visible = true;
	}


	private void _on_Video_pressed()
	{
		hideOptions();
		_Video.Visible = true;
	}


	private void _on_Controls_pressed()
	{
		hideOptions();
		_Controll.Visible = true;
	}
	private void hideOptions(){
		
		_Audio.Visible = false;
		_Video.Visible = false;
		_Controll.Visible = false;
	}
	
}





