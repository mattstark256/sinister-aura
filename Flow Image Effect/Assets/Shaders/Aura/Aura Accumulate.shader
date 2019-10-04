Shader "Aura/Aura Accumulate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_LerpAmount("Lerp Amount", Float) = 0.1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			float _LerpAmount;

			sampler2D _StencilTex;
			float4 _SampledRegion;

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col1 = tex2D(_MainTex, i.uv);
                fixed4 col2 = tex2D(_StencilTex, i.uv * _SampledRegion.xy + _SampledRegion.zw);

				fixed4 col3 = lerp(col1, col2, _LerpAmount);
                return col3;
            }
            ENDCG
        }
    }
}
