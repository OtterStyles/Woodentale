using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class player : Mover
{
    private void FixedUpdate()
    {
        float x = Input.GetAxisRaw("Horizontal");
        float y = Input.GetAxisRaw("Vertical");
        
        UpdateMotor(new Vector3(x,y,0));
    }
}
