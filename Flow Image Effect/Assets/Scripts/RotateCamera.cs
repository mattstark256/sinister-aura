using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateCamera : MonoBehaviour
{
    [SerializeField]
    private Transform cameraFocus, cameraPivot;
    [SerializeField]
    private float radius = 5;
    [SerializeField]
    private float duration = 5;


    void Update()
    {
        transform.position = cameraPivot.transform.position + cameraPivot.transform.rotation * Quaternion.Euler(0, Time.time / duration * 360, 0) * Vector3.forward * radius;
        transform.rotation = Quaternion.LookRotation(cameraFocus.position - transform.position);
    }
}
