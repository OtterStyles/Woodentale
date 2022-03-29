using Godot;
using System;

public class MainMenu : MarginContainer{

	private Label _selectorOne = null;
	private Label _selectorTwo = null;
	private Label _selectorThree = null;
	private int _currentSelection = 0;
	private PackedScene _startScene = (PackedScene)ResourceLoader.Load("res://Scene/Wolrd.tscn");
	private PackedScene _optionScene = (PackedScene)ResourceLoader.Load("res://GUI/Options.tscn");
	public PlayerStats _stats = null;
	
	public override void _Ready()
	{
		_selectorOne = GetNode<Label>("CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector");
		_selectorTwo = GetNode<Label>("CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector");
		_selectorThree = GetNode<Label>("CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector");
		_stats = GetNode<PlayerStats>("/root/PlayerStats");
		setCurrentSelection(0);
	}

	public override void _Process(float delta)
	{
		if (Input.IsActionJustPressed("ui_down") && _currentSelection < 2)
		{
			_currentSelection += 1;
		}
		else if (Input.IsActionJustPressed("ui_up") && _currentSelection > 0)
		{
			_currentSelection -= 1;
		}
		else if (Input.IsActionJustPressed("ui_accept"))
		{
			hanldeSelection(_currentSelection);
		}
		setCurrentSelection(_currentSelection);
	}

	public void setCurrentSelection(int currentSelection)
	{
		_selectorOne.Text = "";
		_selectorTwo.Text = "";
		_selectorThree.Text = "";
		if (currentSelection == 0) _selectorOne.Text = ">";
		else if (currentSelection == 1) _selectorTwo.Text = ">";
		else if (currentSelection == 2) _selectorThree.Text = ">";
	}

	private void hanldeSelection(int currentSelection)
	{
		if (currentSelection == 0)
		{
			resetStats();
			GetTree().ChangeSceneTo(_startScene);    
		}
		else if (currentSelection == 1)
		{
			GetTree().ChangeSceneTo(_optionScene);   
		}
		else if (currentSelection == 2)
		{
			GetTree().Quit();
		}
	}

	private void resetStats()
	{
		_stats.Health = _stats.MaxHealth;
		_stats.Kills = 0;
	}
	
	
}
