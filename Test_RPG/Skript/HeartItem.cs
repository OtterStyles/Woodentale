using Godot;
using System;

public class HeartItem : BasicItemController
{
    [Export()] public int Health;
    private PlayerStats _playerStats = null;

    public override void _Ready()
    {;
        _playerStats = GetNode<PlayerStats>("/root/PlayerStats");
    }

    public override void changeStats()
    {
        if (_playerStats.Health < _playerStats.MaxHealth)
        {
            _playerStats.Health += Health;
        }
        
    }
}
