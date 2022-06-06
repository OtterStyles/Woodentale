using Godot;
using System.Collections.Generic;

public class Inventory : Resource
{
    [Signal]
    public delegate void inventoryChanged();

    [Export()] private List<ItemResource> items
    {
        get { return items;}
        set
        {
            EmitSignal("inventoryChanged", this);
            items = value;
            // https://www.youtube.com/watch?v=hYRN0eYttLc 16:49
        }
    }
    
    
}
