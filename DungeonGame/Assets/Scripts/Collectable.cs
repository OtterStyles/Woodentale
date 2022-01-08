﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Collectable : Collidable
{
    //Logic 
    protected bool collected = false;

    protected override void OnCollide(Collider2D coll)
    {
        if(coll.name == "Player")
        {
            OnCollect();
        }
    }

    protected virtual void OnCollect()
    {
        collected = true;
    }  

}
