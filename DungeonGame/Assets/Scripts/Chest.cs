using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chest : Collectable
{
    public Sprite emptyChest;
    public int persosAmount = 10;

    protected override void OnCollect()
    {
        if (!collected)
        {
            collected = true;
            GetComponent<SpriteRenderer>().sprite = emptyChest;
            GameManager.instance.pesos += persosAmount;
            GameManager.instance.ShowText("+" + persosAmount + " pesos!", 25, Color.red, transform.position, Vector3.up * 25, 1.5f);
        }
    }
}
