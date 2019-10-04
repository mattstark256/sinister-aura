using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField]
    private Transform head;
    [SerializeField]
    private float mouseSensitivity = 3;
    [SerializeField]
    private float moveSpeed = 3;

    private float yaw;
    private float pitch;
    

    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;

        yaw = head.eulerAngles.y;
        pitch = head.eulerAngles.x;
    }
    

    void Update()
    {
        Vector2 mouseVector = new Vector2(Input.GetAxisRaw("Mouse X"), Input.GetAxisRaw("Mouse Y"));
        mouseVector *= mouseSensitivity;
        yaw += mouseVector.x;
        pitch -= mouseVector.y;
        head.rotation = Quaternion.Euler(pitch, yaw, 0);

        Vector3 movementVector = new Vector3(Input.GetAxisRaw("Horizontal"), 0, Input.GetAxisRaw("Vertical"));
        movementVector = movementVector.normalized;
        movementVector *= moveSpeed;
        transform.position += head.rotation * movementVector * Time.deltaTime;
    }
}
