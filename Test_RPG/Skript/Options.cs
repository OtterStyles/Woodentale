using Godot;
using System;

public class Options : MarginContainer{

    private Label _selectorOne = null;
    private Label _selectorTwo = null;
    private Label _selectorThree = null;
    private Label _selectorFour = null;
    private int _currentSelection = 0;
    private PackedScene _MainMenue = (PackedScene)ResourceLoader.Load("res://MainMenu.tscn");
    public PlayerStats _stats = null;
    public EnemyStats _enemyStats = null;
    
    public override void _Ready()
    {
        _selectorOne = GetNode<Label>("CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector");
        _selectorTwo = GetNode<Label>("CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector");
        _selectorThree = GetNode<Label>("CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector");
        _selectorFour = GetNode<Label>("CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/HBoxContainer/Selector");
        _stats = GetNode<PlayerStats>("/root/PlayerStats");
        _enemyStats = GetNode<EnemyStats>("/root/EnemyStats");
        setCurrentSelection(0);
    }

    public override void _Process(float delta)
    {
        if (Input.IsActionJustPressed("ui_down") && _currentSelection < 3)
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
        _selectorFour.Text = "";
        if (currentSelection == 0) _selectorOne.Text = ">";
        else if (currentSelection == 1) _selectorTwo.Text = ">";
        else if (currentSelection == 2) _selectorThree.Text = ">";
        else if (currentSelection == 3) _selectorFour.Text = ">";
    }

    private void hanldeSelection(int currentSelection)
    {
        if (currentSelection == 0)
        {
            setStats(5, 1);
            GetTree().ChangeSceneTo(_MainMenue);    
        }
        else if (currentSelection == 1)
        {
            setStats(4, 1);
            GetTree().ChangeSceneTo(_MainMenue);    
        }
        else if (currentSelection == 2)
        {
            setStats(4, 2);
            GetTree().ChangeSceneTo(_MainMenue);    
        }else if (currentSelection == 3)
        {
            setStats(3, 2);
            GetTree().ChangeSceneTo(_MainMenue);    
        }
    }

    private void setStats(int Health, int damageMult)
    {
        _stats.MaxHealth = Health;
        _enemyStats.Damage = 1;
        _enemyStats.Damage *= damageMult;
    }
    
    
}
