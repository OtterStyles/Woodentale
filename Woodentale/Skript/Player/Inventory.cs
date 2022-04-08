using Godot;
using System.Collections.Generic;

public class Inventory : Resource
{
    [Signal]
    public delegate void inventoryChanged();

    [Export()] private List<ItemResource> items;


    public void setItems(List<ItemResource> newitems){
        items = newitems;
        EmitSignal("inventoryChanged");
    }

    public List<ItemResource> getItems(){
        return items;
    }
    public ItemResource getItems(int index){
        return items[index];
    }
    
    public void addItem(string itemName, int quantity){
        if (quantity <= 0){
            GD.Print("Cant give an quantity less or equal 0");
            return;
        }
        ItemDatabase itemDatabase = ResourceLoader.Load<ItemDatabase>("/root/ItemDatabase");
        ItemResource item = itemDatabase.getItem(itemName);
        if (item == null){
            GD.Print("Could not finde the item");
            return;
        }
        int remaining_quantitiy = quantity;
        int MaxStackSize = 0;
        if (item.Stackable) MaxStackSize = item.MaxStackSize;
        else MaxStackSize = 1;

        if (item.Stackable){
            for (int i = 0; i < items.Count; i++){
                if (remaining_quantitiy == 0) break;
                ItemResource inventorItem = items[i];

                if (inventorItem.Name == item.Name) continue;

                if (inventorItem.Quantity < MaxStackSize){
                    int originalQuantity = inventorItem.Quantity;
                    inventorItem.Quantity = Mathf.Min(originalQuantity + remaining_quantitiy, MaxStackSize);
                    remaining_quantitiy -= inventorItem.Quantity - originalQuantity;
                }
            }
        }
        while (remaining_quantitiy > 0){
            var newItem = new {
                item_reference = item,
                quantity = Mathf.Min(remaining_quantitiy, MaxStackSize);

            };

            
            // items.Add(newItem);
            // remaining_quantitiy -= newItem.Quantity;

        }
    }
}
