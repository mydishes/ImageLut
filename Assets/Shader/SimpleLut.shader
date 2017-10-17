Shader "Custom/SimpleLut" {
	Properties{
		[PerRendererData]_MainTex("Base (RGB)", 2D) = "white" {}
		_LookupMask("Lookup (A)", 2D) = "white" {}
	}
	SubShader
	{
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }
		Cull Off
		LOD 200
		Lighting off
		ZWrite off
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _LookupMask;


			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed4 color = tex2D(_MainTex, i.uv);
				color.r = tex2D(_LookupMask,float2(color.r,0)).r;
				color.g = tex2D(_LookupMask, float2(color.g, 0)).g;
				color.b = tex2D(_LookupMask, float2(color.b, 0)).b;
				return color;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
