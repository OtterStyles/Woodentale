using Godot;
using System;

public class Stats : Node
{ 
    [Export(PropertyHint.Range,"0,100,")]
    public int max_health = 1;
    private int health = 1;

    [Signal]public delegate void noHealth();
    
    public override void _Ready()
    {
        health = max_health;
    }
    
    
    public int Health
    {
        get
        {
            return health;
        }
        set 
        { 
            health = value;
            if(health <= 0)
            {
                
                EmitSignal("noHealth");
            }
        }

    }
}
