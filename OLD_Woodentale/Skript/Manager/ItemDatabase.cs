using Godot;
using System;
using System.Collections.Generic;

public class ItemDatabase : Node
{
    public List<ItemResource> items = new List<ItemResource>();
    public override void _Ready()
    {
        Directory directory = new Directory();
        directory.Open("res://Items/");
        directory.ListDirBegin();

        String filename = directory.GetNext();
        while (filename != null)
        {
            if (!directory.CurrentIsDir())
            {
                items.Add(ResourceLoader.Load<ItemResource>("res://Items/" + filename));
            }
            filename = directory.GetNext();
        }
    }

    public ItemResource getItem(String itemName)
    {
        foreach (ItemResource item in items)
        {
            if (item.Name == itemName)
            {
                return item;
            }
        }
        return null;
    }
    
}
