Shader "Aura/Aura"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_TintColor("Tint Color", Color) = (1, 1, 1, 1)
		_FadeDistance("Fade Distance", Float) = 1
    }
    SubShader
	{ 
		Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
        LOD 100

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"

			// note: no SV_POSITION in this struct
			struct v2f {
				float2 uv : TEXCOORD0;
			};

			v2f vert(
				float4 vertex : POSITION, // vertex position input
				float2 uv : TEXCOORD0, // texture coordinate input
				out float4 outpos : SV_POSITION // clip space position output
				)
			{
				v2f o;
				o.uv = uv;
				outpos = UnityObjectToClipPos(vertex);
				return o;
			}

			sampler2D _MainTex;
			sampler2D _CameraDepthTexture;
			fixed4 _TintColor;
			float _FadeDistance;

			fixed4 frag(v2f i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				col.a = col.r;
				col.rgb = _TintColor.rgb;

				// Fade out the edges
				float edgeDistance = min(min(i.uv.x, 1 - i.uv.x), min(i.uv.y, 1 - i.uv.y));
				col.a *= clamp(edgeDistance * 4, 0, 1);

				// Fade out based on distance to surface behind
				float2 screenUV = screenPos.xy / _ScreenParams;
				float environmentDepth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, screenUV)));
				float quadDepth = LinearEyeDepth(screenPos.z);
				float d = environmentDepth - quadDepth;
				d /= _FadeDistance;
				d = clamp(d, 0, 1);
				col.a *= d;

				return col;
			}
			ENDCG
        }
    }
}
