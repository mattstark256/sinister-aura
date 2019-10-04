using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(Camera))]
public class StencilTextureGenerator : MonoBehaviour
{
    private Camera stencilCam;
    public Camera StencilCam
    {
        get
        {
            if (!stencilCam)
            {
                stencilCam = GetComponent<Camera>();
            }
            return stencilCam;
        }
    }


    private RenderTexture stencilTexture;
    public RenderTexture StencilTexture
    {
        get
        {
            if (!stencilTexture || stencilTexture.width != Screen.width || stencilTexture.height != Screen.height)
            {
                CreateStencilTexture();
            }
            return stencilTexture;
        }
    }


    private void Awake()
    {
        CreateStencilTexture();
    }


    private void CreateStencilTexture()
    {
        if (stencilTexture) stencilTexture.Release();
        stencilTexture = new RenderTexture(Screen.width, Screen.height, 0);
        StencilCam.targetTexture = stencilTexture;
    }
}
